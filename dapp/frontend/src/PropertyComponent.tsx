import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { useState, useEffect } from "react";
import { Spin } from 'antd';
import { Box, Button, Center, Flex } from '@chakra-ui/react';
import { MODULE_ADDRESS, PROVIDER } from './constants';

type Property = {
  location: string;
  living_area: string;
}

export const PropertyComponent = () => {
  // Component logic and state can be defined here
  const { account, signAndSubmitTransaction } = useWallet();

  //
  // State
  //
  const [showForm, setShowForm] = useState(false);
  const [properties, setProperties] = useState<Property[]>([]);
  const [newProperty, setNewProperty] = useState<string>("");
  const [accountHasProperty, setaccountHasProperty] = useState<boolean>(false);
  /// spinner
  const [transactionInProgress, setTransactionInProgress] = useState<boolean>(false);
  
  //
  // Effects
  //

  
  //
  // Functions
  //

  /// createProperty
  const createProperty = async () => {
    if(!account) return [];
    setTransactionInProgress(true);

    // transaction payload to be submitted
    const payload = {
        type: "entry_function_payload",
        function: `${MODULE_ADDRESS}::property::mint_property`,
        type_arguments: [],
        arguments: [
          'a',
          'b',
          'c',
          'd'
        ],
    };
    try {
        // sign and submit tx to chain
        const response = await signAndSubmitTransaction(payload);
        // wait for transaction
        await PROVIDER.waitForTransaction(response.hash);
        setaccountHasProperty(true);
    } catch (error: any) {
      setaccountHasProperty(false); 
    } finally {
      setTransactionInProgress(false);
    }
  }

  //
  // Render
  //
  return (
    // TSX markup defines the component's UI
    <Spin spinning={transactionInProgress}>
      <Button
      onClick={createProperty}
      variant='outline'
      >
        Create Property
      </Button>
      {accountHasProperty && (
        <Box flex={8} mx="auto">
            <Button
            variant='outline'
            _hover={{ backgroundColor: "teal" }}
            >
            Manage Property
            </Button>
        </Box>
      )}
    </Spin>
  );
};
  
  export default PropertyComponent;