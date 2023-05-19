import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { useState, useEffect } from "react";
import {  
  Button, 
  Center, 
  ButtonGroup,
  List,
  ListItem,
  Link,
  Stack
} from '@chakra-ui/react';
import { MODULE_ADDRESS, PROVIDER } from './constants';

type RegisteredProperty = {
  property_address: string;
  owner_address: string;
  timestamp_seconds: number; //TODO: enforce this to uint64
};


export const RegistryComponent = () => {
  // Component logic and state can be defined here
  const { account, signAndSubmitTransaction } = useWallet();

  //
  // States
  //
  const [accountHasRegistry, setaccountHasRegistry] = useState<boolean>(false);
  const [propertyAdded, setPropertyAdded] = useState<boolean>(false);
  const [registeredProperties, setRegisteredProperties] = useState<RegisteredProperty[]>([]);
  /// spinner
  const [transactionInProgress, setTransactionInProgress] = useState<boolean>(false);

  const fetchRegistry = async () => {
    if (!account) return [];
    try {
      const RegistryResource = await PROVIDER.getAccountResource(
        account?.address,
        `${MODULE_ADDRESS}::registry::Registry`,
      )
      setaccountHasRegistry(true);

      // registry table handle
      const tableHandle = (RegistryResource as any).data.properties.handle;
      
      // Table struct from the module
      // properties_list: Table<address, RegisteredProperty>
      let registeredProperties = [];
      let address = "address"

      const tableItem = {
        key_type: "string",
        value_type: `${MODULE_ADDRESS}::registry::registeredProperty`,
        key: `${address}`,
      };
      const registeredProperty = await PROVIDER.getTableItem(tableHandle, tableItem);
      registeredProperties.push(registeredProperty);
      
      // set properties in local state
      setRegisteredProperties(registeredProperties);
    } 
    catch (e: any) {
      setaccountHasRegistry(false);
    }
  };

  //
  // Effects
  //
  useEffect(() => {
    fetchRegistry();
  }, [account?.address, fetchRegistry]);
  
  //
  // Functions
  //

  /// addNewRegistry
  const addNewRegistry = async () => {
    if(!account) return [];
    setTransactionInProgress(true);

    // transaction payload to be submitted
    const payload = {
        type: "entry_function_payload",
        function: `${MODULE_ADDRESS}::registry::Init_registry`,
        type_arguments: [],
        arguments: [],
    };
    try {
        // sign and submit tx to chain
        const response = await signAndSubmitTransaction(payload);
        
        // wait for transaction
        await PROVIDER.waitForTransaction(response.hash);
        setaccountHasRegistry(true);
        
    } catch (error: any) {
      setaccountHasRegistry(false); 
    } finally {
      setTransactionInProgress(false);
    }
  }

  /// registerProperty
  const registerProperty = async () => {
    if(!account) return [];
    setTransactionInProgress(true);

    // transaction payload to be submitted
    const payload = {
        type: "entry_function_payload",
        function: `${MODULE_ADDRESS}::registry::register_property`,
        type_arguments: [],
        arguments: [],
    };
    try {
        // sign and submit tx to chain
        const response = await signAndSubmitTransaction(payload);
        // wait for transaction
        await PROVIDER.waitForTransaction(response.hash);
        setPropertyAdded(true);
    } catch (error: any) {
      setPropertyAdded(false); 
    } finally {
      setTransactionInProgress(false);
    }
  }

  //
  // Render
  //
  // TODO: update UI
  return (
    // TSX markup defines the component's UI
    <Center>
      {!accountHasRegistry ? (
        <ButtonGroup>
          <Button
          onClick={addNewRegistry}
          variant='outline'
          _hover={{ backgroundColor: "teal" }}
        >
          Create Registry
        </Button>
          <Button
            onClick={registerProperty}
          > 
            Register Property
          </Button>
        </ButtonGroup>
      ) : (
            // TODO: Generic error caused by registered properties. check payload
            registeredProperties && (
              <Stack>
                <Button
                  /*onClick={}*/
                  _hover={{ backgroundColor: "teal" }}
                >
                  Manage Registry
                </Button>
                <List>
                    size="sm" borderWidth="1px" borderColor="gray.200" borderRadius="md" spacing={2}
                    {
                      registeredProperties.map((registeredProperty) => (
                        <ListItem 
                        key={registeredProperty.owner_address}
                        title={registeredProperty.property_address}
                        >
                          <Link 
                          href={`https://explorer.aptoslabs.com/account/`} /* TODO: add address */ 
                          isExternal
                          >
                            view
                          </Link>
                        </ListItem>
                      ))
                    }
                  </List>
              </Stack>
            )
          )
      }
    </Center>
    
  );
  /* TODO: include this in a seperate box*/
};
  
  export default RegistryComponent;