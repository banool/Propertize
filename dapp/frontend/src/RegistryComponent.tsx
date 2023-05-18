import { Provider, Network } from "aptos";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { useState, useEffect } from "react";
import { Box, Button, Center } from '@chakra-ui/react';

const provider = new Provider(Network.DEVNET);
const { account, signAndSubmitTransaction } = useWallet();
const moduleAddress = "0xe5b3c9b44e50d066eb405079c55b9740fcc37fddd2bf305ee50a0c5da03d2741";

export const RegistryComponent = () => {
  // Component logic and state can be defined here
  
  //
  // State
  //
  const [accountHasRegistry, setaccountHasRegistry] = useState<boolean>(false);
  /// spinner
  const [transactionInProgress, setTransactionInProgress] = useState<boolean>(false);

  const fetchRegistry = async () => {
    if (!account) return [];
    try {
      const RegistryResource = await provider.getAccountResource(
        account?.address,
        `${moduleAddress}::registry::Registry`,
      )
      setaccountHasRegistry(RegistryResource !== null);
    } catch (e: any) {
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
        function: '${moduleAddress}::registry::Init_registry',
        type_arguments: [],
        arguments: [],
    };
    try {
        // sign and submit tx to chain
        const response = await signAndSubmitTransaction(payload);
        // wait for transaction
        await provider.waitForTransaction(response.hash);
        setaccountHasRegistry(true);
    } catch (error: any) {
      setaccountHasRegistry(false); 
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
    <div>
      {!accountHasRegistry && (
      <Center marginTop="2rem">
        <Box>
          <Button onClick={addNewRegistry} height="40px">
            Add new registry
          </Button>
        </Box>
      </Center>
      )}
    </div>
  );
};
  
  export default RegistryComponent;