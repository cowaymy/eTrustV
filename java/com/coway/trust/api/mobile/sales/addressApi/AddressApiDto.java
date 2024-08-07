package com.coway.trust.api.mobile.sales.addressApi;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;


/**
 * @ClassName : AddressApiDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 24.   KR-JAEMJAEM:)        First creation
 * </pre>
 */
@ApiModel(value = "AddressApiDto", description = "AddressApiDto")
public class AddressApiDto {

	@SuppressWarnings("unchecked")
	public static AddressApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, AddressApiDto.class);
	}

	private String code;
	private String codeDesc;
    private String areaId;
    private String postcode;
    private String fullAddr;
    private String area;
    private int cnt;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getCodeDesc() {
        return codeDesc;
    }

    public void setCodeDesc(String codeDesc) {
        this.codeDesc = codeDesc;
    }

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public String getPostcode() {
        return postcode;
    }

    public void setPostcode(String postcode) {
        this.postcode = postcode;
    }

    public String getFullAddr() {
        return fullAddr;
    }

    public void setFullAddr(String fullAddr) {
        this.fullAddr = fullAddr;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public int getCnt() {
        return cnt;
    }

    public void setCnt(int cnt) {
        this.cnt = cnt;
    }

}
