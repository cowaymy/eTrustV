package com.coway.trust.biz.payment.govEInvoice.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.csv.CSVRecord;

import com.coway.trust.biz.payment.govEInvoice.service.GovEInvcGenerateResponseVO.ErrorDetails;
import com.fasterxml.jackson.annotation.JsonProperty;

public class GovEInvcCheckStatusResponseVO {
    private Boolean Success;
    private String DocumentId;
    private String Status;
    private String Uuid;
    private String LongId;
    private String QrCode;
    private String InternalId;
    private String DateTimeValidated;
    private String CancelDateTime;
    private String RejectRequestTime;
    private List<ErrorDetails> ErrorDetails;

	public Boolean getSuccess() {
		return Success;
	}
	public void setSuccess(Boolean success) {
		Success = success;
	}
	public String getDocumentId() {
		return DocumentId;
	}
	public void setDocumentId(String documentId) {
		DocumentId = documentId;
	}
	public String getStatus() {
		return Status;
	}
	public void setStatus(String status) {
		Status = status;
	}
	public String getUuid() {
		return Uuid;
	}
	public void setUuid(String uuid) {
		Uuid = uuid;
	}
	public String getLongId() {
		return LongId;
	}
	public void setLongId(String longId) {
		LongId = longId;
	}
	public String getQrCode() {
		return QrCode;
	}
	public void setQrCode(String qrCode) {
		QrCode = qrCode;
	}
	public String getInternalId() {
		return InternalId;
	}
	public void setInternalId(String internalId) {
		InternalId = internalId;
	}
	public String getDateTimeValidated() {
		return DateTimeValidated;
	}
	public void setDateTimeValidated(String dateTimeValidated) {
		DateTimeValidated = dateTimeValidated;
	}
	public String getCancelDateTime() {
		return CancelDateTime;
	}
	public void setCancelDateTime(String cancelDateTime) {
		CancelDateTime = cancelDateTime;
	}
	public String getRejectRequestTime() {
		return RejectRequestTime;
	}
	public void setRejectRequestTime(String rejectRequestTime) {
		RejectRequestTime = rejectRequestTime;
	}
	public List<ErrorDetails> getErrorDetails() {
		return ErrorDetails;
	}
	public void setErrorDetails(List<ErrorDetails> errorDetails) {
		ErrorDetails = errorDetails;
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

}