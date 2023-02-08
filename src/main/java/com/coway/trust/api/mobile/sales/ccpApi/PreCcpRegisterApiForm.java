package com.coway.trust.api.mobile.sales.ccpApi;

import java.util.HashMap;
import java.util.Map;
import com.coway.trust.util.BeanConverter;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : PreCcpRegisterApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             		Author          			Description
 * -------------    	-----------     			-------------
 * 2023. 02. 08.    Low Kim Ching   	First creation
 * </pre>
 */
@ApiModel(value = "PreCcpRegisterApiForm", description = "PreCcpRegisterApiForm")
public class PreCcpRegisterApiForm {

    public static PreCcpRegisterApiForm create(Map<String, Object> preCcpMap) {
        return BeanConverter.toBean(preCcpMap, PreCcpRegisterApiForm.class);
    }

	public static Map<String, Object> createMap(PreCcpRegisterApiForm vo){
		Map<String, Object> params = new HashMap<>();
		params.put("selectType", vo.getSelectType());
		params.put("selectKeyword", vo.getSelectKeyword());
        params.put("custId", vo.getCustId());
        params.put("memId", vo.getMemId());
		return params;
	}

	private String selectType;
	private String selectKeyword;
	private int custId;
    private String regId;
    private String yymmdd;
    private String yyyymmdd;
    private String ddmmyyyy;
    private int memId;

    public String getSelectType() {
        return selectType;
    }

    public void setSelectType(String selectType) {
        this.selectType = selectType;
    }

    public String getSelectKeyword() {
        return selectKeyword;
    }

    public void setSelectKeyword(String selectKeyword) {
        this.selectKeyword = selectKeyword;
    }

    public int getCustId() {
        return custId;
    }

    public void setCustId(int custId) {
        this.custId = custId;
    }

    public String getRegId() {
        return regId;
    }

    public void setRegId(String regId) {
        this.regId = regId;
    }

    public String getYyyymmdd() {
        return yyyymmdd;
    }

    public void setYyyymmdd(String yyyymmdd) {
        this.yyyymmdd = yyyymmdd;
    }

    public String getYymmdd() {
        return yymmdd;
    }

    public void setYymmdd(String yymmdd) {
        this.yymmdd = yymmdd;
    }

    public String getDdmmyyyy() {
        return ddmmyyyy;
    }
    public void setDdmmyyyy(String ddmmyyyy) {
        this.ddmmyyyy = ddmmyyyy;
    }

    public int getMemId() {
        return memId;
    }

    public void setMemId(int memId) {
        this.memId = memId;
    }
}
