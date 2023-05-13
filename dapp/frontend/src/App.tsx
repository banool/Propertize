import * as React from "react"
import {
  ChakraProvider,
  Box,
  Text,
  Heading,
  VStack,
  Alert,
  AlertIcon,
  Grid,
  theme,
} from "@chakra-ui/react"
import { ColorModeSwitcher } from "./ColorModeSwitcher"
import { ConnectComponent } from "./ConnectComponent"
import FetchRegistryComponent from "./FetchRegistryComponent"

export const App = () => (
  <ChakraProvider theme={theme}>
    <Box textAlign="center">
      <Grid minH="100vh" p={3}>
        <ColorModeSwitcher justifySelf="flex-end" />
        <Heading>Propertize</Heading>
        <VStack spacing={4}>
          <Alert status='warning'>
              <AlertIcon />
                <Text fontSize="m">
                Only Petra is supported!
              </Text>
            </Alert>
          <ConnectComponent />
          <FetchRegistryComponent />
        </VStack>
      </Grid>
    </Box>
  </ChakraProvider>
)
