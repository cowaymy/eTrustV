/**
 * Proxy_PortType.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.coway.trust.config.ctos.client.xml.proxy.ws;

public interface Proxy_PortType extends java.rmi.Remote {
	public byte[] requestSsm(String input) throws java.rmi.RemoteException;

	public byte[] requestID(String input) throws java.rmi.RemoteException;

	public byte[] requestIDConfirm(String input) throws java.rmi.RemoteException;

	public byte[] generateCtosReport(String input, String type) throws java.rmi.RemoteException;

	public byte[] requestLite(String input) throws java.rmi.RemoteException;

	public byte[] requestConfirm(String input) throws java.rmi.RemoteException;

	public byte[] requestParty(String input) throws java.rmi.RemoteException;

	public byte[] requestPartyConfirm(String input) throws java.rmi.RemoteException;

	public byte[] requestIndex(String input) throws java.rmi.RemoteException;

	public byte[] request(String input) throws java.rmi.RemoteException;

	public byte[] generateCTOSLiteReport(String input, String type) throws java.rmi.RemoteException;

	public byte[] generateTrReport(String input, String type) throws java.rmi.RemoteException;
}
