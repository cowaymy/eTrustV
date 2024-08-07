package com.coway.trust.api.mobile.sales.customerApi;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : CustomerApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 16.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "CustomerApiDto", description = "CustomerApiDto")
public class CustomerApiDto {



	@SuppressWarnings("unchecked")
	public static CustomerApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, CustomerApiDto.class);
	}



	public static Map<String, Object> createMap(CustomerApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("custId", vo.getCustId());
		params.put("name", vo.getName());
		params.put("addrDtl", vo.getAddrDtl());
		params.put("addr", vo.getAddr());
		params.put("typeIdName", vo.getTypeIdName());
        params.put("custAddId", vo.getCustAddId());
        params.put("postcode", vo.getPostcode());
        params.put("custVaNo", vo.getCustVaNo());
        params.put("nationName", vo.getNationName());
        params.put("raceIdName", vo.getRaceIdName());
        params.put("telM1", vo.getTelM1());
        params.put("telO", vo.getTelO());
        params.put("telR", vo.getTelR());
        params.put("email", vo.getEmail());
        params.put("custCntcId", vo.getCustCntcId());
        params.put("typeId", vo.getTypeId());
        params.put("salesOrdId", vo.getSalesOrdId());
        params.put("salesOrdNo", vo.getSalesOrdNo());
        params.put("salesDt", vo.getSalesDt());
        params.put("stusCodeIdName", vo.getStusCodeIdName());
        params.put("appTypeIdName", vo.getAppTypeIdName());
        params.put("stkDescName", vo.getStkDescName());
        params.put("custNric", vo.getNric());
		return params;
	}



	private int custId;
	private String name;
	private String addrDtl;
	private String addr;
	private String typeIdName;
	private int custAddId;
	private String postcode;
	private String custVaNo;
	private String nationName;
	private String raceIdName;
	private String telM1;
    private String telO;
	private String telR;
	private String email;
	private int custCntcId;
    private int typeId;
    private int salesOrdId;
    private int salesOrdNo;
    private String salesDt;
    private String stusCodeIdName;
    private String appTypeIdName;
    private String stkDescName;
    private List<CustomerApiDto> codeList;
    private int codeMasterId;
    private int codeId;
    private String code;
    private String codeName;
    private String codeDesc;
    private String nric;




    public int getSalesOrdNo() {
        return salesOrdNo;
    }



    public void setSalesOrdNo(int salesOrdNo) {
        this.salesOrdNo = salesOrdNo;
    }



    public int getCodeMasterId() {
        return codeMasterId;
    }

    public void setCodeMasterId(int codeMasterId) {
        this.codeMasterId = codeMasterId;
    }

    public int getCodeId() {
        return codeId;
    }

    public void setCodeId(int codeId) {
        this.codeId = codeId;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getCodeName() {
        return codeName;
    }

    public void setCodeName(String codeName) {
        this.codeName = codeName;
    }

    public String getCodeDesc() {
        return codeDesc;
    }

    public void setCodeDesc(String codeDesc) {
        this.codeDesc = codeDesc;
    }

    public List<CustomerApiDto> getCodeList() {
        return codeList;
    }

    public void setCodeList(List<CustomerApiDto> codeList) {
        this.codeList = codeList;
    }

    public int getCustId() {
        return custId;
    }

    public void setCustId(int custId) {
        this.custId = custId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddrDtl() {
        return addrDtl;
    }

    public void setAddrDtl(String addrDtl) {
        this.addrDtl = addrDtl;
    }

    public String getAddr() {
        return addr;
    }

    public void setAddr(String addr) {
        this.addr = addr;
    }

    public String getTypeIdName() {
        return typeIdName;
    }

    public void setTypeIdName(String typeIdName) {
        this.typeIdName = typeIdName;
    }

    public int getCustAddId() {
        return custAddId;
    }

    public void setCustAddId(int custAddId) {
        this.custAddId = custAddId;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getCustVaNo() {
        return custVaNo;
    }

    public void setCustVaNo(String custVaNo) {
        this.custVaNo = custVaNo;
    }

    public String getNationName() {
        return nationName;
    }

    public void setNationName(String nationName) {
        this.nationName = nationName;
    }

    public String getRaceIdName() {
        return raceIdName;
    }

    public void setRaceIdName(String raceIdName) {
        this.raceIdName = raceIdName;
    }

    public String getTelM1() {
        return telM1;
    }

    public void setTelM1(String telM1) {
        this.telM1 = telM1;
    }

    public String getTelR() {
        return telR;
    }

    public void setTelR(String telR) {
        this.telR = telR;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getCustCntcId() {
        return custCntcId;
    }

    public void setCustCntcId(int custCntcId) {
        this.custCntcId = custCntcId;
    }

    public String getTelO() {
        return telO;
    }

    public void setTelO(String telO) {
        this.telO = telO;
    }

    public int getTypeId() {
        return typeId;
    }

    public void setTypeId(int typeId) {
        this.typeId = typeId;
    }

    public int getSalesOrdId() {
        return salesOrdId;
    }

    public void setSalesOrdId(int salesOrdId) {
        this.salesOrdId = salesOrdId;
    }

    public String getSalesDt() {
        return salesDt;
    }

    public void setSalesDt(String salesDt) {
        this.salesDt = salesDt;
    }

    public String getStusCodeIdName() {
        return stusCodeIdName;
    }

    public void setStusCodeIdName(String stusCodeIdName) {
        this.stusCodeIdName = stusCodeIdName;
    }

    public String getAppTypeIdName() {
        return appTypeIdName;
    }

    public void setAppTypeIdName(String appTypeIdName) {
        this.appTypeIdName = appTypeIdName;
    }

    public String getStkDescName() {
        return stkDescName;
    }

    public void setStkDescName(String stkDescName) {
        this.stkDescName = stkDescName;
    }
	public String getNric() {
		return nric;
	}

	public void setNric(String nric) {
		this.nric = nric;
	}
}
