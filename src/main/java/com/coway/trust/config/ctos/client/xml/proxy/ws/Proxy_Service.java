/**
 * Proxy_Service.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.coway.trust.config.ctos.client.xml.proxy.ws;

public interface Proxy_Service extends javax.xml.rpc.Service {
	public String getProxyPortAddress();

	public Proxy_PortType getProxyPort() throws javax.xml.rpc.ServiceException;

	public Proxy_PortType getProxyPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException;
}
