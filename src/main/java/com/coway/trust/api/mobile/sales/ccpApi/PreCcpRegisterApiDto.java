package com.coway.trust.api.mobile.sales.ccpApi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : PreCcpRegisterApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             		Author                 Description
 * -------------    	-----------             -------------
 * 2023. 02. 08.    Low Kim Ching      First creation
 * </pre>
 */
@ApiModel(value = "PreCcpRegisterApiDto", description = "PreCcpRegisterApiDto")
public class PreCcpRegisterApiDto {

    @SuppressWarnings("unchecked")
	public static PreCcpRegisterApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, PreCcpRegisterApiDto.class);
	}

	public static Map<String, Object> createMap(PreCcpRegisterApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("custId", vo.getCustId());
		params.put("custName", vo.getCustName());
		params.put("custMonth", vo.getCustMonth());
		params.put("appvReq", vo.getAppvReq());
		params.put("chsStatus", vo.getChsStatus());
		params.put("chsRsn", vo.getChsRsn());
		return params;
	}


	private int custId;
	private String custName;
	private String custIc;
	private String custMobileno;
	private String custEmail;
	private String chsStatus;
	private String crtDt;
	private String chsRsn;
	private String appvReq;
	private int custMonth;


    public int getCustId() {
        return custId;
    }

    public void setCustId(int custId) {
        this.custId = custId;
    }

    public String getCustName() {
        return custName;
    }

    public void setCustName(String custName) {
        this.custName = custName;
    }

    public String getCustIc() {
        return custIc;
    }

    public void setCustIc(String custIc) {
        this.custIc = custIc;
    }
    public String getCustMobileno() {
        return custMobileno;
    }

    public void setCustMobileno(String custMobileno) {
        this.custMobileno = custMobileno;
    }

    public String getCustEmail() {
        return custEmail;
    }

    public void setCustEmail(String custEmail) {
        this.custEmail = custEmail;
    }

    public String getChsStatus() {
        return chsStatus;
    }

    public void setChsStatus(String chsStatus) {
        this.chsStatus = chsStatus;
    }

    public String getCrtDt() {
        return crtDt;
    }

    public void setCrtDt(String crtDt) {
        this.crtDt = crtDt;
    }
    public int getCustMonth() {
        return custMonth;
    }
    public void setCustMonth(int custMonth) {
        this.custMonth = custMonth;
    }

    public String getAppvReq() {
        return appvReq;
    }
    public void setAppvReq(String appvReq) {
        this.appvReq = appvReq;
    }

    public String getChsRsn() {
        return chsRsn;
    }
    public void setChsRsn(String chsRsn) {
        this.chsRsn = chsRsn;
    }

}
