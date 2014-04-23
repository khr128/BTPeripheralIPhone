//
//  BTPViewController.m
//  BTPeripheralPhone
//
//  Created by khr on 4/20/14.
//  Copyright (c) 2014 khr. All rights reserved.
//

#import "BTPViewController.h"

@interface BTPViewController ()

@end

@implementation BTPViewController {
  CBPeripheralManager *_peripheralManager;
  CBUUID *_serviceUUID, *_characteristicUUID;
  CBMutableCharacteristic *_characteristic;
  CBMutableService *_service;
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
  _serviceUUID = [CBUUID UUIDWithString:@"53C51B97-B2F4-4EB6-B485-3A3595FBFCD2"];
  _characteristicUUID = [CBUUID UUIDWithString:@"3C57404F-B7CD-45C4-9ECF-707EE0528996"];
  
  NSData *data = [@"Hello, Bluetooth!" dataUsingEncoding:NSUTF8StringEncoding];
  _characteristic = [[CBMutableCharacteristic alloc] initWithType: _characteristicUUID
                                                       properties: CBCharacteristicPropertyRead
                                                            value: data
                                                      permissions: CBAttributePermissionsReadable];
  
  _service = [[CBMutableService alloc] initWithType:_serviceUUID primary:YES];
  _service.characteristics = @[_characteristic];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark CBPeripheral delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
  NSLog(@"Peripheral state changed:\n%@", peripheral.description);
  if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
    [_peripheralManager addService:_service];
  }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(NSError *)error {
  NSLog(@"Added service %@", service.description);
  [peripheral startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: @[service.UUID]}];
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
  NSLog(@"Started advertising");
}
@end
