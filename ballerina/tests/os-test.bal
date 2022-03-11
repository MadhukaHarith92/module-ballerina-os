// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/jballerina.java;
import ballerina/test;

@test:Config {}
function testGetEnv() {
    string expectedValue = getExpectedValidEnv();
    test:assertEquals(getEnv("JAVA_HOME"), expectedValue);
}

@test:Config {}
isolated function testGetEnvNegative() {
    test:assertEquals(getEnv("JAVA_XXXX"), "");
}

@test:Config {}
function testGetUserHome() {
    test:assertEquals(getUserHome(), getExpectedUserHome());
}

@test:Config {}
function testGetUsername() {
    test:assertEquals(getUsername(), getExpectedUserName());
}

@test:Config {}
function testSetEnv() {
    Error? result = setEnv("foo", "bar");
    if result is Error {
        test:assertFail("failed to set environment variable: " + result.message());
    } else {
        test:assertEquals(getEnv("foo"), "bar");
    }
}

@test:Config {}
function testSetEnvNegative() {
    Error? result = setEnv("", "bar");
    if result is Error {
        test:assertEquals(result.message(), "Environment key cannot be an empty string");
    } else {
        test:assertFail("setEnv did not return an error for empty string as key");
    }

    result = setEnv("==", "bar");
    if result is Error {
        test:assertEquals(result.message(), "Environment key cannot be == sign");
    } else {
        test:assertFail("setEnv did not return an error for == sign as key");
    }

    result = setEnv("0x00", "bar");
    if result is Error {
        test:assertEquals(result.message(), "Environment key cannot be initial hexadecimal zero character (0x00)");
    } else {
        test:assertFail("setEnv did not return an error for initial hexadecimal zero character (0x00) as key");
    }
}

@test:Config {}
function testUnsetEnv() {
    Error? result = setEnv("foo", "bar");
    if result is Error {
        test:assertFail("failed to set environment variable: " + result.message());
    } else {
        test:assertEquals(getEnv("foo"), "bar");
        result = unsetEnv("foo");
        if result is Error {
            test:assertFail("failed to unset environment variable: " + result.message());
        } else {
            test:assertEquals(getEnv("foo"), "");
        }
    }
}

@test:Config {}
function testUnsetEnvNegative() {
    Error? result = unsetEnv("");
    if result is Error {
        test:assertEquals(result.message(), "Environment key cannot be an empty string");
    } else {
        test:assertFail("setEnv did not return an error for empty string as key");
    }

    result = unsetEnv("==");
    if result is Error {
        test:assertEquals(result.message(), "Environment key cannot be == sign");
    } else {
        test:assertFail("setEnv did not return an error for == sign as key");
    }

    result = unsetEnv("0x00");
    if result is Error {
        test:assertEquals(result.message(), "Environment key cannot be initial hexadecimal zero character (0x00)");
    } else {
        test:assertFail("setEnv did not return an error for initial hexadecimal zero character (0x00) as key");
    }
}

@test:Config {}
function testListEnv() {
    map<string> env = listEnv();
    test:assertTrue(env.length() > 0);
}

@test:Config {}
function testGetSystemPropertyNegative() {
    test:assertEquals(getSystemProperty("non-existing-key"), "");
}

function getExpectedValidEnv() returns string = @java:Method {
    name: "testValidEnv",
    'class: "io.ballerina.stdlib.os.testutils.OSTestUtils"
} external;

function getExpectedUserHome() returns string = @java:Method {
    name: "testGetUserHome",
    'class: "io.ballerina.stdlib.os.testutils.OSTestUtils"
} external;

function getExpectedUserName() returns string = @java:Method {
    name: "testGetUserName",
    'class: "io.ballerina.stdlib.os.testutils.OSTestUtils"
} external;

function getSystemProperty(string key) returns string = @java:Method {
    name: "getSystemProperty",
    'class: "io.ballerina.stdlib.os.utils.OSUtils"
} external;
