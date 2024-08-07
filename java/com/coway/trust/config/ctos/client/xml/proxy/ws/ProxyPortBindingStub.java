/**
 * ProxyPortBindingStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package com.coway.trust.config.ctos.client.xml.proxy.ws;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.Signature;
import java.security.SignatureException;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Map;
import java.util.Vector;
import java.util.Base64;

import javax.xml.namespace.QName;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.client.Stub;
import org.apache.axis.transport.http.HTTPConstants;
import org.apache.axis.utils.JavaUtils;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import com.coway.trust.util.CommonUtils;
import ucar.nc2.stream.NcStreamProto.Header;

public class ProxyPortBindingStub extends Stub implements Proxy_PortType {

  private Vector cachedSerClasses = new Vector();
  private Vector cachedSerQNames = new Vector();
  private Vector cachedSerFactories = new Vector();
  private Vector cachedDeserFactories = new Vector();

	private static String TOKEN_URL = "https://sso.ctos.com.my/auth/realms/CTOSNET/protocol/openid-connect/token";
	private static String clientId = "Coway_jwt";
	private static String clientSecret = "7676613c-1e85-4693-8b9b-8ec7f860a6f3";
	private static String userName = "b065000_xml";
	private static String password =  "Cmsb#7143!";
	private static String privateKeyFile =  "/home/etrust_user/rsa-private-ctos-jwt-prd.pem";


	static org.apache.axis.description.OperationDesc[] _operations;

	static {
		_operations = new org.apache.axis.description.OperationDesc[12];
		_initOperationDesc1();
		_initOperationDesc2();
	}

	private static void _initOperationDesc1() {
		org.apache.axis.description.OperationDesc oper;
		org.apache.axis.description.ParameterDesc param;
		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("requestSsm");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[0] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("requestID");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[1] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("requestIDConfirm");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[2] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("generateCtosReport");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new org.apache.axis.description.ParameterDesc(new QName("", "type"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[3] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("requestLite");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[4] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("requestConfirm");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[5] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("requestParty");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[6] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("requestPartyConfirm");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[7] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("requestIndex");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[8] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("request");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[9] = oper;

	}

	private static void _initOperationDesc2() {
		org.apache.axis.description.OperationDesc oper;
		org.apache.axis.description.ParameterDesc param;
		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("generateCTOSLiteReport");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new org.apache.axis.description.ParameterDesc(new QName("", "type"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[10] = oper;

		oper = new org.apache.axis.description.OperationDesc();
		oper.setName("generateTrReport");
		param = new org.apache.axis.description.ParameterDesc(new QName("", "input"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		param = new org.apache.axis.description.ParameterDesc(new QName("", "type"),
				org.apache.axis.description.ParameterDesc.IN, new QName("http://www.w3.org/2001/XMLSchema", "string"),
				String.class, false, false);
		param.setOmittable(true);
		oper.addParameter(param);
		oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "base64Binary"));
		oper.setReturnClass(byte[].class);
		oper.setReturnQName(new QName("", "return"));
		oper.setStyle(org.apache.axis.constants.Style.WRAPPED);
		oper.setUse(org.apache.axis.constants.Use.LITERAL);
		_operations[11] = oper;

	}

	public ProxyPortBindingStub() throws org.apache.axis.AxisFault {
		this(null);
	}

	public ProxyPortBindingStub(java.net.URL endpointURL, javax.xml.rpc.Service service)
			throws org.apache.axis.AxisFault {
		this(service);
		super.cachedEndpoint = endpointURL;
	}

	public ProxyPortBindingStub(javax.xml.rpc.Service service) throws org.apache.axis.AxisFault {
		if (service == null) {
			super.service = new Service();
		} else {
			super.service = service;
		}
		((Service) super.service).setTypeMappingVersion("1.2");
	}

	protected Call createCall() throws java.rmi.RemoteException {
		try {
			Call _call = super._createCall();
			if (super.maintainSessionSet) {
				_call.setMaintainSession(super.maintainSession);
			}
			if (super.cachedUsername != null) {
				_call.setUsername(super.cachedUsername);
			}
			if (super.cachedPassword != null) {
				_call.setPassword(super.cachedPassword);
			}
			if (super.cachedEndpoint != null) {
				_call.setTargetEndpointAddress(super.cachedEndpoint);
			}
			if (super.cachedTimeout != null) {
				_call.setTimeout(super.cachedTimeout);
			}
			if (super.cachedPortName != null) {
				_call.setPortName(super.cachedPortName);
			}
			Enumeration keys = super.cachedProperties.keys();
			while (keys.hasMoreElements()) {
				String key = (String) keys.nextElement();
				_call.setProperty(key, super.cachedProperties.get(key));
			}
			return _call;
		} catch (Throwable _t) {
			throw new org.apache.axis.AxisFault("Failure trying to get the Call object", _t);
		}
	}

	public byte[] requestSsm(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[0]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "requestSsm"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] requestID(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[1]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "requestID"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] requestIDConfirm(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[2]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "requestIDConfirm"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] generateCtosReport(String input, String type) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[3]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "generateCtosReport"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input, type });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] requestLite(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[4]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "requestLite"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] requestConfirm(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[5]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "requestConfirm"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] requestParty(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[6]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "requestParty"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] requestPartyConfirm(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[7]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "requestPartyConfirm"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] requestIndex(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[8]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "requestIndex"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] request(String input) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[9]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "request"));

		addAuthenticationHeader(_call);
		if (((Map<String, Object>) _call.getProperty(HTTPConstants.REQUEST_HEADERS)).containsKey("error")) {
			throw new java.rmi.RemoteException((String) ((Map<String, Object>) _call.getProperty(HTTPConstants.REQUEST_HEADERS)).get("error"));
		}
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] generateCTOSLiteReport(String input, String type) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[10]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "generateCTOSLiteReport"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input, type });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	public byte[] generateTrReport(String input, String type) throws java.rmi.RemoteException {
		if (super.cachedEndpoint == null) {
			throw new org.apache.axis.NoEndPointException();
		}
		Call _call = createCall();
		_call.setOperation(_operations[11]);
		_call.setUseSOAPAction(true);
		_call.setSOAPActionURI("");
		_call.setEncodingStyle(null);
		_call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
		_call.setProperty(org.apache.axis.AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
		_call.setSOAPVersion(org.apache.axis.soap.SOAPConstants.SOAP11_CONSTANTS);
		_call.setOperationName(new QName("http://ws.proxy.xml.ctos.com.my/", "generateTrReport"));

		addAuthenticationHeader(_call);
		setRequestHeaders(_call);
		setAttachments(_call);
		try {
			Object _resp = _call.invoke(new Object[] { input, type });

			if (_resp instanceof java.rmi.RemoteException) {
				throw (java.rmi.RemoteException) _resp;
			} else {
				extractAttachments(_call);
				try {
					return (byte[]) _resp;
				} catch (Exception _exception) {
					return (byte[]) JavaUtils.convert(_resp, byte[].class);
				}
			}
		} catch (org.apache.axis.AxisFault axisFaultException) {
			throw axisFaultException;
		}
	}

	private void addAuthenticationHeader(Call _call) {
		Map<String, Object> headers = new Hashtable<String, Object>();

		Map<String, Object> token = new HashMap<String, Object>();
		try {
      		token = requestMFAToken();
    	} catch (Exception e) {
     		System.out.println(e);
    }
		if (token.containsKey("error")) {
			headers.put("error", token.get("error"));
		}
	    headers.put("username", "b065000_xml");
		headers.put("password", "Wo74Sm#1");
//		headers.put("password", "	Cmsb#7143!");


//		headers.put("username", "coway_uat");
//		headers.put("password", "ghuEDL481KLrh@og&g");
		headers.put("Authorization", token.get("token_type") + " " + token.get("access_token"));
		_call.setProperty(HTTPConstants.REQUEST_HEADERS, headers);
	}

  private static Map<String, Object> requestMFAToken() throws IOException, JSONException{
	  Map<String, Object> map = new HashMap<String, Object>();
    try {
      URL url = new URL(TOKEN_URL);

      HttpURLConnection con = (HttpURLConnection)url.openConnection();
      con.setRequestMethod("POST");
      con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
      con.setDoOutput(true);
      System.out.println("con=============:" + con);
      String urlParameters  = "grant_type=password"+
          "&client_id=" + clientId +
          "&client_secret=" + clientSecret +
          "&username=" + userName +
          "&password=" + URLEncoder.encode(password,"UTF-8") +
          "&client_assertion_type=" + URLEncoder.encode("urn:ietf:params:oauth:client-assertion-type:jwt-bearer", "UTF-8") +
          "&client_assertion=" + URLEncoder.encode(getJwtToken(clientId, privateKeyFile), "UTF-8")
          ;
      System.out.println("urlParameters=======" + urlParameters);
      System.out.println("test=============:" + URLEncoder.encode(getJwtToken(clientId, privateKeyFile), "UTF-8"));
      System.out.println("test2=============:" + getJwtToken(clientId, privateKeyFile));

      OutputStreamWriter wr= new OutputStreamWriter(con.getOutputStream());
      wr.write(urlParameters.getBytes("UTF-8").toString());

      System.out.println("wr=============:" + wr);

      OutputStream os = con.getOutputStream();
      os.write(urlParameters.getBytes("UTF-8"));

      System.out.println("os=============:" + os);

      os.flush();
      os.close();

      int responseCode = con.getResponseCode();

      System.out.println("responseCode=============:" + responseCode);

        if (responseCode == HttpURLConnection.HTTP_OK) { //success
          BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
          String inputLine;
          StringBuffer response = new StringBuffer();

          while ((inputLine = in.readLine()) != null) {
            response.append(inputLine);
          }

          System.out.println("response=============:" + response);

          in.close();

          String sbString = response.toString();
          JSONObject json = new JSONObject(sbString);

          Iterator<?> keys = json.keys();

          while( keys.hasNext() ){
              String key = (String)keys.next();
              String value = json.getString(key);
              map.put(key, value);
          }

      }
       return map;
    } catch(Exception e) {
      System.out.println("Could not get an access token: " + e.getMessage());
      map.put("error", CommonUtils.printStackTraceToString(e));
      return map;
    }
  }

  private static String fileToString(String path) throws IOException {
    InputStream input = new FileInputStream(new File(path));
    String content = inputStreamToString(input);
    input.close();
    return content;
  }

  private static String inputStreamToString(InputStream input) throws IOException {
    StringBuilder result = new StringBuilder();
    byte[] buffer = new byte[1024];
    int read = input.read(buffer);
    while(read > 0) {
      result.append(new String(buffer, 0, read));
      read = input.read(buffer);
    }

    return result.toString();
  }

  private static String getJwtToken(String clientId, String privateKeyFile) throws IOException, NoSuchAlgorithmException, InvalidKeyException, InvalidKeySpecException, SignatureException {
    try {
      long now = System.currentTimeMillis();
      long nowSeconds = now / 1000;
      long expiry = nowSeconds + 300;
      String tokenId = "TKN_" + now;

      // Generate the header
      String header = "{\"alg\":\"RS256\",\"typ\":\"JWT\"}";
      //System.out.println("Header: " + header);
      header = Base64.getEncoder().encodeToString(header.getBytes());

      // Generate the payload
      String payload = "{\"jti\":\""+tokenId+"\",\"sub\":\""+clientId+"\",\"iss\":\""+clientId+"\",\"aud\":\""+TOKEN_URL+"\",\"exp\":"+expiry+",\"iat\":"+nowSeconds+"}";
      //System.out.println("Payload: " + payload);
      payload = Base64.getEncoder().encodeToString(payload.getBytes());

      // Generate the signature
      String privateKey = fileToString(privateKeyFile);
      privateKey = privateKey.replaceAll("-----BEGIN PRIVATE KEY-----", "")
          .replaceAll("-----END PRIVATE KEY-----", "")
          .replaceAll("\n", "");
      //System.out.println("Private key: " + privateKey);
      java.security.Security.addProvider(new org.bouncycastle.jce.provider.BouncyCastleProvider());
      PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(Base64.getMimeDecoder().decode(privateKey));
      KeyFactory keyFactory = KeyFactory.getInstance("RSA");
      Signature privateSignature = Signature.getInstance("SHA256withRSA");
      privateSignature.initSign(keyFactory.generatePrivate(spec));
      privateSignature.update((header + "." + payload).getBytes());
      String signature = Base64.getEncoder().encodeToString(privateSignature.sign());

      String jwtToken = header + "." + payload + "." + signature;
      //System.out.println("JWT Token: " + jwtToken);

      return jwtToken;
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }

  public static void main(String rgs[]) throws JSONException, IOException, InvalidKeyException, NoSuchAlgorithmException, InvalidKeySpecException, SignatureException{
    System.out.println(requestMFAToken());
  }
}
