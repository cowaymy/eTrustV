package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.coway.trust.cmmn.model.GridDataSet;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 *
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class OrderVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private SalesOrderMVO salesOrderMVO; //SALES ORDER MASTER

	private SalesOrderDVO salesOrderDVO; //SALES ORDER DETAILS

	private InstallationVO installationVO; //INSTALLATION MASTER
	
	private RentPaySetVO rentPaySetVO; //RENT PAY SET
	
	private CustBillMasterVO custBillMasterVO; //CUSTOMER BILL MASTER
	
	private RentalSchemeVO rentalSchemeVO; //RENTAL SCHEME
	
	private AccClaimAdtVO accClaimAdtVO; //CLAIM ADT
	
	private CcpDecisionMVO ccpDecisionMVO;//CCP MASTER
	
	private EStatementReqVO eStatementReqVO; //CCP DETAILS
	
	private SalesOrderContractVO salesOrderContractVO; //SALES ORDER CONTRACT
	
	private GridDataSet<DocSubmissionVO> docSubmissionVOList;
	
	private List<DocSubmissionVO> docSubVOList;
	
	private CallEntryVO callEntryVO;
	
	private CallResultVO callResultVO;
	
	private InstallEntryVO installEntryVO;
	
	private InstallResultVO installResultVO;
	
	private SrvMembershipSalesVO srvMembershipSalesVO;
	
	private SrvConfigurationVO srvConfigurationVO;
	
	private List<SrvConfigSettingVO> srvConfigSettingVOList;
	
	private SrvConfigPeriodVO srvConfigPeriodVO;
	
	private List<SrvConfigFilterVO> srvConfigFilterVOList;
	
	private List<SalesOrderLogVO> salesOrderLogVOList;
	
	private GSTEURCertificateVO gSTEURCertificateVO;

	private int custTypeId;

	private int raceId;

	private String billGrp;
	
	private int orderAppType;
	
	private String sInstallDate;
	
	private int itmStkId;
	
	private String dInstallDate;
	
	private int salesOrdId;
	
	private int preOrdId;
	
	private String preOrderYN;
	
	private String copyOrderBulkYN;
	
	private int copyQty;
	
	private String salesOrdNoFirst;
	
	public SalesOrderMVO getSalesOrderMVO() {
		return salesOrderMVO;
	}

	public void setSalesOrderMVO(SalesOrderMVO salesOrderMVO) {
		this.salesOrderMVO = salesOrderMVO;
	}

	public SalesOrderDVO getSalesOrderDVO() {
		return salesOrderDVO;
	}

	public void setSalesOrderDVO(SalesOrderDVO salesOrderDVO) {
		this.salesOrderDVO = salesOrderDVO;
	}

	public InstallationVO getInstallationVO() {
		return installationVO;
	}

	public void setInstallationVO(InstallationVO installationVO) {
		this.installationVO = installationVO;
	}

	public RentPaySetVO getRentPaySetVO() {
		return rentPaySetVO;
	}

	public void setRentPaySetVO(RentPaySetVO rentPaySetVO) {
		this.rentPaySetVO = rentPaySetVO;
	}

	public CustBillMasterVO getCustBillMasterVO() {
		return custBillMasterVO;
	}

	public void setCustBillMasterVO(CustBillMasterVO custBillMasterVO) {
		this.custBillMasterVO = custBillMasterVO;
	}

	public RentalSchemeVO getRentalSchemeVO() {
		return rentalSchemeVO;
	}

	public void setRentalSchemeVO(RentalSchemeVO rentalSchemeVO) {
		this.rentalSchemeVO = rentalSchemeVO;
	}

	public AccClaimAdtVO getAccClaimAdtVO() {
		return accClaimAdtVO;
	}

	public void setAccClaimAdtVO(AccClaimAdtVO accClaimAdtVO) {
		this.accClaimAdtVO = accClaimAdtVO;
	}

	public CcpDecisionMVO getCcpDecisionMVO() {
		return ccpDecisionMVO;
	}

	public void setCcpDecisionMVO(CcpDecisionMVO ccpDecisionMVO) {
		this.ccpDecisionMVO = ccpDecisionMVO;
	}

	public EStatementReqVO geteStatementReqVO() {
		return eStatementReqVO;
	}

	public void seteStatementReqVO(EStatementReqVO eStatementReqVO) {
		this.eStatementReqVO = eStatementReqVO;
	}

	public SalesOrderContractVO getSalesOrderContractVO() {
		return salesOrderContractVO;
	}

	public void setSalesOrderContractVO(SalesOrderContractVO salesOrderContractVO) {
		this.salesOrderContractVO = salesOrderContractVO;
	}

	public GridDataSet<DocSubmissionVO> getDocSubmissionVOList() {
		return docSubmissionVOList;
	}

	public void setDocSubmissionVOList(GridDataSet<DocSubmissionVO> docSubmissionVOList) {
		this.docSubmissionVOList = docSubmissionVOList;
	}

	public CallEntryVO getCallEntryVO() {
		return callEntryVO;
	}

	public void setCallEntryVO(CallEntryVO callEntryVO) {
		this.callEntryVO = callEntryVO;
	}

	public CallResultVO getCallResultVO() {
		return callResultVO;
	}

	public void setCallResultVO(CallResultVO callResultVO) {
		this.callResultVO = callResultVO;
	}

	public InstallEntryVO getInstallEntryVO() {
		return installEntryVO;
	}

	public void setInstallEntryVO(InstallEntryVO installEntryVO) {
		this.installEntryVO = installEntryVO;
	}

	public InstallResultVO getInstallResultVO() {
		return installResultVO;
	}

	public void setInstallResultVO(InstallResultVO installResultVO) {
		this.installResultVO = installResultVO;
	}

	public SrvMembershipSalesVO getSrvMembershipSalesVO() {
		return srvMembershipSalesVO;
	}

	public void setSrvMembershipSalesVO(SrvMembershipSalesVO srvMembershipSalesVO) {
		this.srvMembershipSalesVO = srvMembershipSalesVO;
	}

	public SrvConfigurationVO getSrvConfigurationVO() {
		return srvConfigurationVO;
	}

	public void setSrvConfigurationVO(SrvConfigurationVO srvConfigurationVO) {
		this.srvConfigurationVO = srvConfigurationVO;
	}

	public List<SrvConfigSettingVO> getSrvConfigSettingVOList() {
		return srvConfigSettingVOList;
	}

	public void setSrvConfigSettingVOList(List<SrvConfigSettingVO> srvConfigSettingVOList) {
		this.srvConfigSettingVOList = srvConfigSettingVOList;
	}

	public SrvConfigPeriodVO getSrvConfigPeriodVO() {
		return srvConfigPeriodVO;
	}

	public void setSrvConfigPeriodVO(SrvConfigPeriodVO srvConfigPeriodVO) {
		this.srvConfigPeriodVO = srvConfigPeriodVO;
	}

	public List<SrvConfigFilterVO> getSrvConfigFilterVOList() {
		return srvConfigFilterVOList;
	}

	public void setSrvConfigFilterVOList(List<SrvConfigFilterVO> srvConfigFilterVOList) {
		this.srvConfigFilterVOList = srvConfigFilterVOList;
	}

	public List<SalesOrderLogVO> getSalesOrderLogVOList() {
		return salesOrderLogVOList;
	}

	public void setSalesOrderLogVOList(List<SalesOrderLogVO> salesOrderLogVOList) {
		this.salesOrderLogVOList = salesOrderLogVOList;
	}

	public GSTEURCertificateVO getgSTEURCertificateVO() {
		return gSTEURCertificateVO;
	}

	public void setgSTEURCertificateVO(GSTEURCertificateVO gSTEURCertificateVO) {
		this.gSTEURCertificateVO = gSTEURCertificateVO;
	}

	public int getCustTypeId() {
		return custTypeId;
	}

	public void setCustTypeId(int custTypeId) {
		this.custTypeId = custTypeId;
	}

	public int getRaceId() {
		return raceId;
	}

	public void setRaceId(int raceId) {
		this.raceId = raceId;
	}

	public String getBillGrp() {
		return billGrp;
	}

	public void setBillGrp(String billGrp) {
		this.billGrp = billGrp;
	}

	public List<DocSubmissionVO> getDocSubVOList() {
		return docSubVOList;
	}

	public void setDocSubVOList(List<DocSubmissionVO> docSubVOList) {
		this.docSubVOList = docSubVOList;
	}

	public int getOrderAppType() {
		return orderAppType;
	}

	public void setOrderAppType(int orderAppType) {
		this.orderAppType = orderAppType;
	}

	public String getsInstallDate() {
		return sInstallDate;
	}

	public void setsInstallDate(String sInstallDate) {
		this.sInstallDate = sInstallDate;
	}

	public int getItmStkId() {
		return itmStkId;
	}

	public void setItmStkId(int itmStkId) {
		this.itmStkId = itmStkId;
	}

	public String getdInstallDate() {
		return dInstallDate;
	}

	public void setdInstallDate(String dInstallDate) {
		this.dInstallDate = dInstallDate;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public int getPreOrdId() {
		return preOrdId;
	}

	public void setPreOrdId(int preOrdId) {
		this.preOrdId = preOrdId;
	}

	public String getPreOrderYN() {
		return preOrderYN;
	}

	public void setPreOrderYN(String preOrderYN) {
		this.preOrderYN = preOrderYN;
	}

	public String getCopyOrderBulkYN() {
		return copyOrderBulkYN;
	}

	public void setCopyOrderBulkYN(String copyOrderBulkYN) {
		this.copyOrderBulkYN = copyOrderBulkYN;
	}

	public int getCopyQty() {
		return copyQty;
	}

	public void setCopyQty(int copyQty) {
		this.copyQty = copyQty;
	}

	public String getSalesOrdNoFirst() {
		return salesOrdNoFirst;
	}

	public void setSalesOrdNoFirst(String salesOrdNoFirst) {
		this.salesOrdNoFirst = salesOrdNoFirst;
	}

}