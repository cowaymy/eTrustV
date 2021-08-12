package com.coway.trust.config.ctos.client.xml.proxy.ws;

import java.rmi.RemoteException;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.coway.trust.AppConstants;
import com.coway.trust.cmmn.exception.ApplicationException;

@Component
public class Proxy implements Proxy_PortType {

	private static final Logger LOGGER = LoggerFactory.getLogger(Proxy.class);
	private String _endpoint = null;
	private Proxy_PortType proxy_PortType = null;
	private String proxyAddress;

	@Autowired
	public Proxy(@Value("${ctos.soap.proxy.address}") String proxyAddress) {
		this.proxyAddress = proxyAddress;
		_initProxy();
	}

	// public Proxy(String endpoint, @Value("${ctos.soap.proxy.address}") String proxyAddress) {
	// this.proxyAddress = proxyAddress;
	// _endpoint = endpoint;
	// _initProxy();
	// }
	private void _initProxy() {

		if (StringUtils.isEmpty(proxyAddress)) {
			throw new ApplicationException(AppConstants.FAIL, "proxyAddress is empty !!!!");
		}

		try {
			proxy_PortType = (new Proxy_ServiceLocator(proxyAddress)).getProxyPort();
			if (proxy_PortType != null) {
				if (_endpoint != null)
					((javax.xml.rpc.Stub) proxy_PortType)._setProperty("javax.xml.rpc.service.endpoint.address",
							_endpoint);
				else
					_endpoint = (String) ((javax.xml.rpc.Stub) proxy_PortType)
							._getProperty("javax.xml.rpc.service.endpoint.address");
			}

		} catch (javax.xml.rpc.ServiceException serviceException) {
			LOGGER.error("initProxyProxy error : {}", serviceException.getMessage());
		}
	}

	public String getEndpoint() {
		return _endpoint;
	}

	public void setEndpoint(String endpoint) {
		_endpoint = endpoint;
		if (proxy_PortType != null)
			((javax.xml.rpc.Stub) proxy_PortType)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);

	}

	public Proxy_PortType getProxy_PortType() {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType;
	}

	public byte[] requestSsm(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.requestSsm(input);
	}

	public byte[] requestID(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.requestID(input);
	}

	public byte[] requestIDConfirm(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.requestIDConfirm(input);
	}

	public byte[] generateCtosReport(String input, String type) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.generateCtosReport(input, type);
	}

	public byte[] requestLite(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.requestLite(input);
	}

	public byte[] requestConfirm(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.requestConfirm(input);
	}

	public byte[] requestParty(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.requestParty(input);
	}

	public byte[] requestPartyConfirm(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.requestPartyConfirm(input);
	}

	public byte[] requestIndex(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.requestIndex(input);
	}

	public byte[] request(String input) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.request(input);
	}

	public byte[] generateCTOSLiteReport(String input, String type) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.generateCTOSLiteReport(input, type);
	}

	public byte[] generateTrReport(String input, String type) throws RemoteException {
		if (proxy_PortType == null)
			_initProxy();
		return proxy_PortType.generateTrReport(input, type);
	}

}
