import * as React from "react"
import {
  ChakraProvider,
  Box,
  Text,
  Heading,
  Stack,
  Divider,
  VStack,
  Alert,
  AlertIcon,
  Grid,
  theme,
  Flex,
  Spacer,
  ButtonGroup,
} from "@chakra-ui/react"
import { ColorModeSwitcher } from "./ColorModeSwitcher"
import { ConnectComponent } from "./ConnectComponent"
import { RegistryComponent } from "./RegistryComponent"
import { PropertyComponent } from "./PropertyComponent"

export const App = () => (
  <ChakraProvider theme={theme}>
    <Grid  p={3}>  
      <Flex minWidth='max-content' alignItems='center' gap='2'>
        <Box p='2'>
          <Heading>Propertize</Heading>
        </Box>
        <Spacer />
        <ButtonGroup gap='2'>
          <ConnectComponent />
          <Alert status='warning'>
              <AlertIcon />
                <Text fontSize="xs">
                Only Petra is supported!
              </Text>
            </Alert>
          <ColorModeSwitcher justifySelf="flex-end" />
        </ButtonGroup>
      </Flex>
    </Grid>
    
    <Box textAlign="center">
      <Grid minH="100vh" p={3}>
        
        
        <VStack spacing={4}>
          
          <Flex justify="center" mt={32}>
          
          </Flex>

          <Stack direction='row' h='100px' p={4}>
            <Box p='5'>
              <Text fontSize="large">
                Registry
              </Text> 
            </Box>
                <RegistryComponent />         
          </Stack>

          <Divider orientation='horizontal' />

          <Stack direction='row' h='100px' p={4}>
            <Box p='1'>
              <Text fontSize="large">
                Property
              </Text> 
            </Box>
                <PropertyComponent />         
          </Stack>
            

        </VStack>
      </Grid>
    </Box>
  </ChakraProvider>
)
