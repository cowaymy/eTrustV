package com.coway.trust.api.mobile.payment.fundTransferApi;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : FundTransferApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 10. 21.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "FundTransferApiDto", description = "FundTransferApiDto")
public class FundTransferApiDto {



	@SuppressWarnings("unchecked")
	public static FundTransferApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, FundTransferApiDto.class);
	}



	public static Map<String, Object> createMap(FundTransferApiDto vo){
		Map<String, Object> params = new HashMap<>();
		params.put("codeId", vo.getCodeId());
		params.put("codeName", vo.getCodeName());
        params.put("ftOrdNo", vo.getFtOrdNo());
        params.put("ftCustName", vo.getFtCustName());
        params.put("ftStusId", vo.getFtStusId());
        params.put("ftStusName", vo.getFtStusName());
        params.put("ftProductName", vo.getFtProductName());
        params.put("ftAppTypeId", vo.getFtAppTypeId());
		return params;
	}



	private int codeId;
	private String codeName;
    private String ftOrdNo;
    private String ftCustName;
    private int ftStusId;
    private String ftStusName;
    private String ftProductName;
    private int ftAppTypeId;



    public int getCodeId() {
        return codeId;
    }

    public void setCodeId(int codeId) {
        this.codeId = codeId;
    }

    public String getCodeName() {
        return codeName;
    }

    public void setCodeName(String codeName) {
        this.codeName = codeName;
    }

    public String getFtOrdNo() {
        return ftOrdNo;
    }

    public void setFtOrdNo(String ftOrdNo) {
        this.ftOrdNo = ftOrdNo;
    }

    public String getFtCustName() {
        return ftCustName;
    }

    public void setFtCustName(String ftCustName) {
        this.ftCustName = ftCustName;
    }

    public int getFtStusId() {
        return ftStusId;
    }

    public void setFtStusId(int ftStusId) {
        this.ftStusId = ftStusId;
    }

    public String getFtStusName() {
        return ftStusName;
    }

    public void setFtStusName(String ftStusName) {
        this.ftStusName = ftStusName;
    }

    public String getFtProductName() {
        return ftProductName;
    }

    public void setFtProductName(String ftProductName) {
        this.ftProductName = ftProductName;
    }

    public int getFtAppTypeId() {
        return ftAppTypeId;
    }

    public void setFtAppTypeId(int ftAppTypeId) {
        this.ftAppTypeId = ftAppTypeId;
    }
}
