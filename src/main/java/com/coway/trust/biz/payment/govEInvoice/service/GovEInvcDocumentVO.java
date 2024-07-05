package com.coway.trust.biz.payment.govEInvoice.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.csv.CSVRecord;

import com.fasterxml.jackson.annotation.JsonProperty;

public class GovEInvcDocumentVO {
		private List<DocumentVO> Documents;
		private String version;

		public List<DocumentVO> getDocuments() {
			return Documents;
		}
		public void setDocuments(List<DocumentVO> documents) {
			Documents = documents;
		}
		public String getVersion() {
			return version;
		}
		public void setVersion(String version) {
			this.version = version;
		}

		// Inner class start
	    public static class DocumentVO {
	    	private String DocumentData;
		    private String DocumentFormat;
		    private String UniqueIdentifier;
		    private CustomFields CustomFields;

		    public void Invoice(Map<String, Object> mapValue) {
		    	this.DocumentData = mapValue.get("documentData").toString();
		    	this.DocumentFormat = mapValue.get("format").toString();
		    	this.UniqueIdentifier = mapValue.get("uin").toString();
		    	this.CustomFields = new CustomFields();
		    	CustomFields.setLabel("Internal Number");
		    	CustomFields.setValue(mapValue.get("invNo").toString());
		    }

			public String getDocumentData() {
				return DocumentData;
			}
			public void setDocumentData(String documentData) {
				DocumentData = documentData;
			}
			public String getDocumentFormat() {
				return DocumentFormat;
			}
			public void setDocumentFormat(String documentFormat) {
				DocumentFormat = documentFormat;
			}
			public String getUniqueIdentifier() {
				return UniqueIdentifier;
			}
			public void setUniqueIdentifier(String uniqueIdentifier) {
				UniqueIdentifier = uniqueIdentifier;
			}
			public CustomFields getCustomFields() {
				return CustomFields;
			}
			public void setCustomFields(CustomFields customFields) {
				CustomFields = customFields;
			}
	    }

	    public static class CustomFields {
	    	private String Label;
	    	private String Value;

			public String getLabel() {
				return Label;
			}
			public void setLabel(String label) {
				Label = label;
			}
			public String getValue() {
				return Value;
			}
			public void setValue(String value) {
				this.Value = value;
			}
	    }


	}