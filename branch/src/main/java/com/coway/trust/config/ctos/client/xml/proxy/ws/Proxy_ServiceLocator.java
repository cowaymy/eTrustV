/**
 * Proxy_ServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.coway.trust.config.ctos.client.xml.proxy.ws;

public class Proxy_ServiceLocator extends org.apache.axis.client.Service implements Proxy_Service {

	public Proxy_ServiceLocator(String ProxyPort_address) {
		this.ProxyPort_address = ProxyPort_address;
	}

	public Proxy_ServiceLocator(org.apache.axis.EngineConfiguration config) {
		super(config);
	}

	public Proxy_ServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName)
			throws javax.xml.rpc.ServiceException {
		super(wsdlLoc, sName);
	}

	// Use to get a proxy class for ProxyPort
	private java.lang.String ProxyPort_address;// = "http://enq.cmctos.com.my:8080/ctos/Proxy";

	public java.lang.String getProxyPortAddress() {
		return ProxyPort_address;
	}

	// The WSDD service name defaults to the port name.
	private java.lang.String ProxyPortWSDDServiceName = "ProxyPort";

	public java.lang.String getProxyPortWSDDServiceName() {
		return ProxyPortWSDDServiceName;
	}

	public void setProxyPortWSDDServiceName(java.lang.String name) {
		ProxyPortWSDDServiceName = name;
	}

	public Proxy_PortType getProxyPort() throws javax.xml.rpc.ServiceException {
		java.net.URL endpoint;
		try {
			endpoint = new java.net.URL(ProxyPort_address);
		} catch (java.net.MalformedURLException e) {
			throw new javax.xml.rpc.ServiceException(e);
		}
		return getProxyPort(endpoint);
	}

	public Proxy_PortType getProxyPort(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
		try {
			ProxyPortBindingStub _stub = new ProxyPortBindingStub(portAddress, this);
			_stub.setPortName(getProxyPortWSDDServiceName());
			return _stub;
		} catch (org.apache.axis.AxisFault e) {
			return null;
		}
	}

	public void setProxyPortEndpointAddress(java.lang.String address) {
		ProxyPort_address = address;
	}

	/**
	 * For the given interface, get the stub implementation. If this service has
	 * no port for the given interface, then ServiceException is thrown.
	 */
	public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
		try {
			if (Proxy_PortType.class.isAssignableFrom(serviceEndpointInterface)) {
				ProxyPortBindingStub _stub = new ProxyPortBindingStub(new java.net.URL(ProxyPort_address), this);
				_stub.setPortName(getProxyPortWSDDServiceName());
				return _stub;
			}
		} catch (java.lang.Throwable t) {
			throw new javax.xml.rpc.ServiceException(t);
		}
		throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  "
				+ (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
	}

	/**
	 * For the given interface, get the stub implementation. If this service has
	 * no port for the given interface, then ServiceException is thrown.
	 */
	public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface)
			throws javax.xml.rpc.ServiceException {
		if (portName == null) {
			return getPort(serviceEndpointInterface);
		}
		java.lang.String inputPortName = portName.getLocalPart();
		if ("ProxyPort".equals(inputPortName)) {
			return getProxyPort();
		} else {
			java.rmi.Remote _stub = getPort(serviceEndpointInterface);
			((org.apache.axis.client.Stub) _stub).setPortName(portName);
			return _stub;
		}
	}

	public javax.xml.namespace.QName getServiceName() {
		return new javax.xml.namespace.QName("http://ws.proxy.xml.ctos.com.my/", "Proxy");
	}

	private java.util.HashSet ports = null;

	public java.util.Iterator getPorts() {
		if (ports == null) {
			ports = new java.util.HashSet();
			ports.add(new javax.xml.namespace.QName("http://ws.proxy.xml.ctos.com.my/", "ProxyPort"));
		}
		return ports.iterator();
	}

	/**
	 * Set the endpoint address for the specified port name.
	 */
	public void setEndpointAddress(java.lang.String portName, java.lang.String address)
			throws javax.xml.rpc.ServiceException {

		if ("ProxyPort".equals(portName)) {
			setProxyPortEndpointAddress(address);
		} else { // Unknown Port Name
			throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
		}
	}

	/**
	 * Set the endpoint address for the specified port name.
	 */
	public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address)
			throws javax.xml.rpc.ServiceException {
		setEndpointAddress(portName.getLocalPart(), address);
	}

}
