import { Provider, Network } from "aptos";
import { useWallet } from "@aptos-labs/wallet-adapter-react";
import { useState, useEffect } from "react";
import { Box, Button, Center } from '@chakra-ui/react';

const provider = new Provider(Network.DEVNET);

const FetchRegistryComponent = () => {
    // Component logic and state can be defined here
    const { account } = useWallet();

    //
    // State
    //
    const [accountHasRegistry, setaccountHasRegistry] = useState<boolean>(false);

    //
    // Effects
    //
    useEffect(() => {
        fetchRegistry();
      }, [account?.address]);

    const fetchRegistry = async () => {
        if (!account) return [];
        const moduleAddress = "0x1";
        try {
          const RegistryResource = await provider.getAccountResource(
            account.address,
            `${moduleAddress}::registry::Registry`
          );
          setaccountHasRegistry(true);
        } catch (e: any) {
          setaccountHasRegistry(false);
        }
      };
    
    //
    // Render
    //
    return (
        // TSX markup defines the component's UI
        <div>
            {!accountHasRegistry && (
            <Center marginTop="2rem">
                <Box>
                    <Button height="40px">
                        Add new registry
                    </Button>
                </Box>
            </Center>
            )}
        </div>
    );
    };
  
  export default FetchRegistryComponent;