package com.coway.trust.biz.payment.govEInvoice.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.csv.CSVRecord;

import com.fasterxml.jackson.annotation.JsonProperty;

public class GovEInvcGenerateResponseVO {
		private Boolean Success;
		private List<DocumentResponses> DocumentResponses;
		private List<ErrorDetails> ErrorDetails;

		public Boolean getSuccess() {
			return Success;
		}

		public void setSuccess(Boolean success) {
			Success = success;
		}

		public List<DocumentResponses> getDocumentResponses() {
			return DocumentResponses;
		}

		public void setDocumentResponses(List<DocumentResponses> documentResponses) {
			DocumentResponses = documentResponses;
		}

		public List<ErrorDetails> getErrorDetails() {
			return ErrorDetails;
		}

		public void setErrorDetails(List<ErrorDetails> errorDetails) {
			ErrorDetails = errorDetails;
		}

		// Inner class start
	    public static class DocumentResponses {
	    	private String DocumentId;
		    private String UniqueId;
		    private Boolean Success;
		    private String Uuid;
		    private String InternalId;
		    private List<ErrorDetails> ErrorDetails;
		    private List<WarningDetails> WarningDetails;

//		    public void Invoice(Map<String, Object> mapValue) {
//	    	this.DocumentData = mapValue.get("documentData").toString();
//	    	this.DocumentFormat = mapValue.get("format").toString();
//	    	this.UniqueIdentifier = mapValue.get("uin").toString();
//	    	this.CustomFields = new CustomFields();
//	    	CustomFields.setLabel("Internal Number");
//	    	CustomFields.setValue(mapValue.get("invNo").toString());
//	    }

			public String getDocumentId() {
				return DocumentId;
			}
			public void setDocumentId(String documentId) {
				DocumentId = documentId;
			}
			public String getUniqueId() {
				return UniqueId;
			}
			public void setUniqueId(String uniqueId) {
				UniqueId = uniqueId;
			}
			public Boolean getSuccess() {
				return Success;
			}
			public void setSuccess(Boolean success) {
				Success = success;
			}
			public String getInternalId() {
				return InternalId;
			}
			public void setInternalId(String internalId) {
				InternalId = internalId;
			}
			public String getUuid() {
				return Uuid;
			}
			public void setUuid(String uuid) {
				Uuid = uuid;
			}
			public List<ErrorDetails> getErrorDetails() {
				return ErrorDetails;
			}
			public void setErrorDetails(List<ErrorDetails> errorDetails) {
				ErrorDetails = errorDetails;
			}
			public List<WarningDetails> getWarningDetails() {
				return WarningDetails;
			}
			public void setWarningDetails(List<WarningDetails> warningDetails) {
				WarningDetails = warningDetails;
			}
	    }

	    public static class ErrorDetails {
	    	private String ErrorCode;
	    	private String Message;
	    	private String ErrorSource;
	    	private String Path;

			public String getErrorCode() {
				return ErrorCode;
			}
			public void setErrorCode(String errorCode) {
				ErrorCode = errorCode;
			}
			public String getMessage() {
				return Message;
			}
			public void setMessage(String message) {
				Message = message;
			}
			public String getErrorSource() {
				return ErrorSource;
			}
			public void setErrorSource(String errorSource) {
				ErrorSource = errorSource;
			}
			public String getPath() {
				return Path;
			}
			public void setPath(String path) {
				Path = path;
			}
	    }

	    public static class WarningDetails {
	    	private String Code;
	    	private String Message;

			public String getCode() {
				return Code;
			}
			public void setCode(String code) {
				Code = code;
			}
			public String getMessage() {
				return Message;
			}
			public void setMessage(String message) {
				Message = message;
			}
	    }
	}