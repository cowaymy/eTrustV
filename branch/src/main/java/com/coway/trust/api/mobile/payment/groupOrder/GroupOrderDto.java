package com.coway.trust.api.mobile.payment.groupOrder;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : GroupOrderDto.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 19.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "GroupOrderDto", description = "GroupOrder Dto")
public class GroupOrderDto {

    @ApiModelProperty(value = "salesOrderNo")
    private String salesOrderNo;

    @ApiModelProperty(value = "custName")
    private String custName;

    @ApiModelProperty(value = "custBillGrpNo")
    private String custBillGrpNo;

    @ApiModelProperty(value = "salesDt")
    private String salesDt;

    @ApiModelProperty(value = "appTypeId")
    private int appTypeId;

    @ApiModelProperty(value = "appTypeName")
    private String appTypeName;

    @ApiModelProperty(value = "stkId")
    private int stkId;

    @ApiModelProperty(value = "stkDesc")
    private String stkDesc;

    @ApiModelProperty(value = "custId")
    private int custId;

    @ApiModelProperty(value = "salesOrdNo")
    private String salesOrdNo;

    @ApiModelProperty(value = "salesOrdId")
    private int salesOrdId;

    @ApiModelProperty(value = "topYn")
    private String topYn;

    @ApiModelProperty(value = "custBillId")
    private int custBillId;

    @ApiModelProperty(value = "isMain")
    private String isMain;

    @ApiModelProperty(value = "product")
    private String product;

    @ApiModelProperty(value = "name")
    private String name;

    @ApiModelProperty(value = "reqStusYn")
    private String reqStusYn;

    @ApiModelProperty(value = "custBillGrpNoNm")
    private String custBillGrpNoNm;

    @ApiModelProperty(value = "stusCodeId")
    private int stusCodeId;

    @ApiModelProperty(value = "stusCodeName")
    private String stusCodeName;

    @ApiModelProperty(value = "stusCodeCode")
    private String stusCodeCode;

    @ApiModelProperty(value = "mobTicketNo")
    private int mobTicketNo;


	public int getMobTicketNo() {
		return mobTicketNo;
	}

	public void setMobTicketNo(int mobTicketNo) {
		this.mobTicketNo = mobTicketNo;
	}

	public String getCustBillGrpNoNm() {
		return custBillGrpNoNm;
	}

	public void setCustBillGrpNoNm(String custBillGrpNoNm) {
		this.custBillGrpNoNm = custBillGrpNoNm;
	}

	public String getReqStusYn() {
		return reqStusYn;
	}

	public void setReqStusYn(String reqStusYn) {
		this.reqStusYn = reqStusYn;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getIsMain() {
		return isMain;
	}

	public void setIsMain(String isMain) {
		this.isMain = isMain;
	}

	public String getProduct() {
		return product;
	}

	public void setProduct(String product) {
		this.product = product;
	}

	public String getSalesOrderNo() {
		return salesOrderNo;
	}

	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}

	public String getCustName() {
		return custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public String getCustBillGrpNo() {
		return custBillGrpNo;
	}

	public void setCustBillGrpNo(String custBillGrpNo) {
		this.custBillGrpNo = custBillGrpNo;
	}

	public String getSalesDt() {
		return salesDt;
	}

	public void setSalesDt(String salesDt) {
		this.salesDt = salesDt;
	}

	public int getAppTypeId() {
		return appTypeId;
	}

	public void setAppTypeId(int appTypeId) {
		this.appTypeId = appTypeId;
	}

	public String getAppTypeName() {
		return appTypeName;
	}

	public void setAppTypeName(String appTypeName) {
		this.appTypeName = appTypeName;
	}

	public int getStkId() {
		return stkId;
	}

	public void setStkId(int stkId) {
		this.stkId = stkId;
	}

	public String getStkDesc() {
		return stkDesc;
	}

	public void setStkDesc(String stkDesc) {
		this.stkDesc = stkDesc;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}


	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public String getTopYn() {
		return topYn;
	}

	public void setTopYn(String topYn) {
		this.topYn = topYn;
	}
	public int getCustBillId() {
		return custBillId;
	}

	public void setCustBillId(int custBillId) {
		this.custBillId = custBillId;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public String getStusCodeName() {
		return stusCodeName;
	}

	public void setStusCodeName(String stusCodeName) {
		this.stusCodeName = stusCodeName;
	}

	public String getStusCodeCode() {
		return stusCodeCode;
	}

	public void setStusCodeCode(String stusCodeCode) {
		this.stusCodeCode = stusCodeCode;
	}

	public static GroupOrderDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, GroupOrderDto.class);
	}
}
