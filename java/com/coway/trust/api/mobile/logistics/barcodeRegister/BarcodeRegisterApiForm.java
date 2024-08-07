package com.coway.trust.api.mobile.logistics.barcodeRegister;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "BarcodeRegisterApiForm", description = "바코드 등록 API Form")
public class BarcodeRegisterApiForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CT100337,T010", example = "CT100337")
	private String userId;

	@ApiModelProperty(value = "", example = "")
	private String delvryNo;

	@ApiModelProperty(value = "", example = "")
	private String reqstNo;

	@ApiModelProperty(value = "", example = "")
	private String itmCode;

	@ApiModelProperty(value = "", example = "")
	private String scanNo;

	@ApiModelProperty(value = "", example = "")
	private String serialNo;

	@ApiModelProperty(value = "", example = "")
	private String fromLocId;

	@ApiModelProperty(value = "", example = "")
	private String toLocId;

	@ApiModelProperty(value = "", example = "")
	private String trnscType;

	@ApiModelProperty(value = "", example = "")
	private String ioType;

    @ApiModelProperty(value = "", example = "")
	private String errcode;

    @ApiModelProperty(value = "", example = "")
	private String errmsg;

	public static BarcodeRegisterApiForm create(Map<String, Object> map) {
        return BeanConverter.toBean(map, BarcodeRegisterApiForm.class);
    }

	public static Map<String, Object> createMap(BarcodeRegisterApiForm barcodeRegisterApiForm) {
		Map<String, Object> params = new HashMap<>();

		params.put("userId", barcodeRegisterApiForm.getUserId());
		params.put("delvryNo", barcodeRegisterApiForm.getDelvryNo());
		params.put("reqstNo", barcodeRegisterApiForm.getReqstNo());
		params.put("itmCode", barcodeRegisterApiForm.getItmCode());
		params.put("scanNo", barcodeRegisterApiForm.getScanNo());
		params.put("serialNo", barcodeRegisterApiForm.getSerialNo());
		params.put("fromLocId", barcodeRegisterApiForm.getFromLocId());
		params.put("toLocId", barcodeRegisterApiForm.getToLocId());
		params.put("trnscType", barcodeRegisterApiForm.getTrnscType());
		params.put("ioType", barcodeRegisterApiForm.getIoType());

		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getDelvryNo() {
		return delvryNo;
	}

	public void setDelvryNo(String delvryNo) {
		this.delvryNo = delvryNo;
	}

	public String getReqstNo() {
		return reqstNo;
	}

	public void setReqstNo(String reqstNo) {
		this.reqstNo = reqstNo;
	}

	public String getItmCode() {
		return itmCode;
	}

	public void setItmCode(String itmCode) {
		this.itmCode = itmCode;
	}

	public String getScanNo() {
		return scanNo;
	}

	public void setScanNo(String scanNo) {
		this.scanNo = scanNo;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public String getFromLocId() {
		return fromLocId;
	}

	public void setFromLocId(String fromLocId) {
		this.fromLocId = fromLocId;
	}

	public String getToLocId() {
		return toLocId;
	}

	public void setToLocId(String toLocId) {
		this.toLocId = toLocId;
	}

	public String getTrnscType() {
		return trnscType;
	}

	public void setTrnscType(String trnscType) {
		this.trnscType = trnscType;
	}

	public String getIoType() {
		return ioType;
	}

	public void setIoType(String ioType) {
		this.ioType = ioType;
	}

    public String getErrcode() {
        return errcode;
    }

    public void setErrcode(String errcode) {
        this.errcode = errcode;
    }

    public String getErrmsg() {
        return errmsg;
    }

    public void setErrmsg(String errmsg) {
        this.errmsg = errmsg;
    }

}
