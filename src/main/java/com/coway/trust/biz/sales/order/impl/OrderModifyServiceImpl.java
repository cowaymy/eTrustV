/**
 * 
 */
package com.coway.trust.biz.sales.order.impl;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.impl.CommonMapper;
import com.coway.trust.biz.sales.customer.impl.CustomerMapper;
import com.coway.trust.biz.sales.order.OrderModifyService;
import com.coway.trust.biz.sales.order.OrderRegisterService;
import com.coway.trust.biz.sales.order.vo.AccClaimAdtVO;
import com.coway.trust.biz.sales.order.vo.CallEntryVO;
import com.coway.trust.biz.sales.order.vo.CallResultVO;
import com.coway.trust.biz.sales.order.vo.CcpDecisionMVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterHistoryVO;
import com.coway.trust.biz.sales.order.vo.CustBillMasterVO;
import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.EStatementReqVO;
import com.coway.trust.biz.sales.order.vo.GSTEURCertificateVO;
import com.coway.trust.biz.sales.order.vo.InstallEntryVO;
import com.coway.trust.biz.sales.order.vo.InstallResultVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.OrderModifyVO;
import com.coway.trust.biz.sales.order.vo.OrderVO;
import com.coway.trust.biz.sales.order.vo.ReferralVO;
import com.coway.trust.biz.sales.order.vo.RentPaySetVO;
import com.coway.trust.biz.sales.order.vo.RentalSchemeVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderContractVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderDVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderMVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigFilterVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigPeriodVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigSettingVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigurationVO;
import com.coway.trust.biz.sales.order.vo.SrvMembershipSalesVO;
import com.coway.trust.biz.sales.promotion.vo.PromotionVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoDVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoFreeGiftVO;
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.GridDataSet;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.common.DocTypeConstants;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("orderModifyService")
public class OrderModifyServiceImpl extends EgovAbstractServiceImpl implements OrderModifyService{

	private static Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);
	
	@Resource(name = "orderModifyMapper")
	private OrderModifyMapper orderModifyMapper;

	@Resource(name = "orderDetailMapper")
	private OrderDetailMapper orderDetailMapper;

	@Resource(name = "orderRegisterMapper")
	private OrderRegisterMapper orderRegisterMapper;

	@Resource(name = "customerMapper")
	private CustomerMapper customerMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

	@Override
	public void updateOrderBasinInfo(Map<String, Object> params, SessionVO sessionVO) {

		logger.info("!@###### OrderModifyServiceImpl.updateOrderBasinInfo");

		params.put("updUserId", sessionVO.getUserId());
		
		if(Integer.valueOf((String)params.get("appTypeId")) != SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT) {
			params.put("installDur", 0);
		}

		orderModifyMapper.updateSalesOrderM(params);
	}
	
	@Override
	public EgovMap selectBillGrpMailingAddr(Map<String, Object> params) throws Exception {

		EgovMap orderInfo = orderRegisterMapper.selectSalesOrderM(params);

		params.put("custBillId", orderInfo.get("custBillId"));

		EgovMap billGrpInfo = orderModifyMapper.selectBillGroupByBillGroupID(params);
		
		List<EgovMap> billGrpOrd  = orderModifyMapper.selectBillGroupOrder(params);

		billGrpInfo.put("totOrder", billGrpOrd.size());
		
		params.put("custAddId", billGrpInfo.get("custBillAddId"));

		EgovMap mailAddrInfo = customerMapper.selectCustomerViewMainAddress(params);
		
		billGrpInfo.put("fullAddress", mailAddrInfo.get("fullAddress"));
		
		return billGrpInfo;
	}
	
	@Override
	public EgovMap checkNricEdit(Map<String, Object> params) throws Exception {

		int checkNricCnt  = orderModifyMapper.selectNricCheckCnt(params);
		int checkNricCnt2 = orderModifyMapper.selectNricCheckCnt2(params);
		
		boolean isEditable = checkNricCnt == checkNricCnt2 ? true : false;
		
		EgovMap outMap = new EgovMap();
		
		outMap.put("isEditable", isEditable);

		return outMap;
	}

	@Override
	public EgovMap checkNricExist(Map<String, Object> params) throws Exception {

		EgovMap outMap = orderModifyMapper.selectNricExist(params);

		return outMap;
	}

	@Override
	public EgovMap selectBillGrpCntcPerson(Map<String, Object> params) throws Exception {

		EgovMap orderInfo = orderRegisterMapper.selectSalesOrderM(params);
		
		logger.info("!@###### custBillId:"+orderInfo.get("custBillId"));
		
		params.put("custBillId", orderInfo.get("custBillId"));

		EgovMap billGrpInfo = orderModifyMapper.selectBillGroupByBillGroupID(params);
		
		List<EgovMap> billGrpOrd  = orderModifyMapper.selectBillGroupOrder(params);
		
		//logger.info("!@###### billGrpOrd.size():"+billGrpOrd.size());
		if(billGrpOrd != null && billGrpOrd.size() > 0) {
			billGrpInfo.put("totOrder", billGrpOrd.size());
			params.put("custCntcId", billGrpInfo.get("custBillCntId"));

			logger.info("!@###### custBillCustId:"+billGrpInfo.get("custBillCustId"));

			EgovMap custAddInfo = customerMapper.selectCustomerViewMainContact(params);
			
			custAddInfo.put("code",	CommonUtils.isEmpty(custAddInfo.get("code")) ? "" : custAddInfo.get("code"));
			custAddInfo.put("name1",	CommonUtils.isEmpty(custAddInfo.get("name1")) ? "" : custAddInfo.get("name1"));
			
			billGrpInfo.put("custAddInfo", custAddInfo);
		}
		
		return billGrpInfo;
	}

	@Override
	public void updateOrderMailingAddress(Map<String, Object> params, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### OrderModifyServiceImpl.updateOrderMailingAddress");

		CustBillMasterHistoryVO custBillMasterHistoryVO = new CustBillMasterHistoryVO();
		
		this.preprocBillMasterHistory(custBillMasterHistoryVO, params, sessionVO, SalesConstants.ORDER_EDIT_TYPE_CD_MAL);
		
		orderModifyMapper.insertCustBillMasterHistory(custBillMasterHistoryVO);

		Map<String, Object> inMap = new HashMap<String, Object>();
		
		inMap.put("custBillAddId", params.get("custAddId"));
		inMap.put("updUserId", sessionVO.getUserId());
		inMap.put("custBillId", params.get("billGroupId"));
		inMap.put("salesOrdId", params.get("salesOrdId"));

		orderModifyMapper.updateCustBillMaster(inMap);
		
		orderModifyMapper.updateCustAddId(inMap);
	}
	
	@Override
	public void updateCntcPerson(Map<String, Object> params, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### OrderModifyServiceImpl.updateOrderMailingAddress");

		CustBillMasterHistoryVO custBillMasterHistoryVO = new CustBillMasterHistoryVO();
		
		this.preprocBillMasterHistory(custBillMasterHistoryVO, params, sessionVO, SalesConstants.ORDER_EDIT_TYPE_CD_CNT);
		
		orderModifyMapper.insertCustBillMasterHistory(custBillMasterHistoryVO);

		Map<String, Object> inMap = new HashMap<String, Object>();
		
		inMap.put("custBillCntId", params.get("custCntcId"));
		inMap.put("updUserId", sessionVO.getUserId());
		inMap.put("custBillId", params.get("billGroupId"));
		inMap.put("salesOrdId", params.get("salesOrdId"));

		orderModifyMapper.updateCustBillMaster(inMap);
		
		orderModifyMapper.updateCustAddId(inMap);
	}
	
	@Override
	public void updateNric(Map<String, Object> params, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### OrderModifyServiceImpl.updateNric");

		params.put("updUserId", sessionVO.getUserId());

		orderModifyMapper.updateNric(params);
	}

	@Override
	public void saveDocSubmission(OrderVO orderVO, SessionVO sessionVO) throws Exception {

		logger.info("!@###### OrderModifyServiceImpl.saveDocSubmission");
		
		GridDataSet<DocSubmissionVO>    documentList     = orderVO.getDocSubmissionVOList();

		List<DocSubmissionVO> docSubVOList = documentList.getUpdate(); // 수정 리스트 얻기
		
		int salesOrdId = orderVO.getSalesOrdId();
		
		for(DocSubmissionVO docSubVO : docSubVOList) {
			if(docSubVO.getChkfield() == 1) {
				
				docSubVO.setDocSoId(salesOrdId);
				docSubVO.setDocSubTypeId(SalesConstants.CCP_DOC_SUB_CODE_ID_ICS);
				docSubVO.setDocMemId(0);
				docSubVO.setCrtUserId(sessionVO.getUserId());
				docSubVO.setUpdUserId(sessionVO.getUserId());
				
				orderModifyMapper.saveDocSubmission(docSubVO);
			}
			else {
				
				docSubVO.setUpdUserId(sessionVO.getUserId());
				
				orderModifyMapper.updateDocSubmissionDel(docSubVO);
			}
		}
	}
	
	@Override
	public void updatePaymentChannel(Map<String, Object> params, SessionVO sessionVO) throws Exception {

		logger.info("!@###### OrderModifyServiceImpl.updatePaymentChannel");
		
		RentPaySetVO rentPaySetVO = new RentPaySetVO();
		
		this.preprocRentPaySet(rentPaySetVO, params, sessionVO);

		orderModifyMapper.updatePaymentChannel(rentPaySetVO);
		
		SalesOrderMVO salesOrderMVO = new SalesOrderMVO();
		
		salesOrderMVO.setSalesOrdId(Long.parseLong((String)params.get("salesOrdId")));		
		salesOrderMVO.setUpdUserId(sessionVO.getUserId());
		salesOrderMVO.setEcash(rentPaySetVO.getModeId() == 131 ? 1 : 0);
		
		orderModifyMapper.updateECashInfo(salesOrderMVO);
	}
	
	private void preprocRentPaySet(RentPaySetVO rentPaySetVO, Map<String, Object> params, SessionVO sessionVO) throws ParseException {
		logger.info("!@###### preprocRentPaySet START ");
		
		int iRentPayMode = Integer.parseInt((String) params.get("rentPayMode"));
		
		rentPaySetVO.setRentPayId(Integer.parseInt((String) params.get("rentPayId")));
//		rentPaySetVO.setSalesOrdId(Integer.parseInt((String) params.get("salesOrdId")));
		rentPaySetVO.setModeId(iRentPayMode);
		rentPaySetVO.setCustCrcId(iRentPayMode == 131 ? Integer.parseInt((String) params.get("rentPayCRCId")) : 0);
		rentPaySetVO.setCustAccId(iRentPayMode == 132 ? Integer.parseInt((String) params.get("hiddenRentPayBankAccID")) : 0);
		rentPaySetVO.setBankId(iRentPayMode == 131 ? Integer.parseInt((String) params.get("rentPayCRCBankId")) : iRentPayMode == 132 ? Integer.parseInt((String) params.get("hiddenAccBankId")) : 0);
		rentPaySetVO.setDdApplyDt(CommonUtils.isNotEmpty(params.get("applyDate")) ? (String) params.get("applyDate") : SalesConstants.DEFAULT_DATE );
		rentPaySetVO.setDdSubmitDt(CommonUtils.isNotEmpty(params.get("submitDate")) ? (String) params.get("submitDate") : SalesConstants.DEFAULT_DATE );
		rentPaySetVO.setDdStartDt(CommonUtils.isNotEmpty(params.get("startDate")) ? (String) params.get("startDate") : SalesConstants.DEFAULT_DATE );
		rentPaySetVO.setDdRejctDt(CommonUtils.isNotEmpty(params.get("rejectDate")) ? (String) params.get("rejectDate") : SalesConstants.DEFAULT_DATE );
		rentPaySetVO.setFailResnId("1".equals((String) params.get("chkRejectDate")) ? Integer.parseInt((String) params.get("rejectReason")) : 0);
		rentPaySetVO.setUpdUserId(sessionVO.getUserId());		
//		rentPaySetVO.setStusCodeId(1);		
		rentPaySetVO.setIs3rdParty("1".equals((String) params.get("thrdParty")) ? 1 : 0);
		rentPaySetVO.setCustId("1".equals((String) params.get("thrdParty")) ? Integer.parseInt((String) params.get("hiddenThrdPartyId")) : 0);
//		rentPaySetVO.setEditTypeId(0);
		rentPaySetVO.setNricOld((String) params.get("rentPayIC"));
		rentPaySetVO.setIssuNric(CommonUtils.isNotEmpty(params.get("rentPayIC")) ? (String) params.get("rentPayIC") : "1".equals((String) params.get("thrdParty")) ? (String) params.get("thrdPartyNric") : (String) params.get("custNric"));
//		rentPaySetVO.setAeonCnvr(0);
//		rentPaySetVO.setRem("");
		rentPaySetVO.setLastApplyUser(sessionVO.getUserId());
		rentPaySetVO.setPayTrm(Integer.parseInt((String) params.get("payTerm")));
	}
	
	private void preprocBillMasterHistory(CustBillMasterHistoryVO custBillMasterHistoryVO, Map<String, Object> params, SessionVO sessionVO, String ordEditType) throws ParseException {
		logger.info("!@###### preprocBillMasterHistory START ");
		
		custBillMasterHistoryVO.setCustBillId(Integer.parseInt((String) params.get("billGroupId")));
		custBillMasterHistoryVO.setHistCrtUserId(sessionVO.getUserId());
		custBillMasterHistoryVO.setSysHistRem("");
		custBillMasterHistoryVO.setUserHistRem((String) params.get("sysHistRem"));
		custBillMasterHistoryVO.setSalesOrdIdOld(0);
		custBillMasterHistoryVO.setSalesOrdIdNw(0);
		custBillMasterHistoryVO.setCntcIdOld(0);
		custBillMasterHistoryVO.setCntcIdNw(0);
		custBillMasterHistoryVO.setAddrIdOld(0);
		custBillMasterHistoryVO.setAddrIdNw(0);
		custBillMasterHistoryVO.setSalesOrdIdOld(0);
		custBillMasterHistoryVO.setSalesOrdIdNw(0);
		custBillMasterHistoryVO.setRemOld("");
		custBillMasterHistoryVO.setRemNw("");
		custBillMasterHistoryVO.setEmailOld("");
		custBillMasterHistoryVO.setEmailNw("");
		custBillMasterHistoryVO.setIsEStateOld(0);
		custBillMasterHistoryVO.setIsEStateNw(0);
		custBillMasterHistoryVO.setIsSmsOld(0);
		custBillMasterHistoryVO.setIsSmsNw(0);
		custBillMasterHistoryVO.setIsPostOld(0);
		custBillMasterHistoryVO.setIsPostNw(0);
		custBillMasterHistoryVO.setTypeId(0);
		
		if(SalesConstants.ORDER_EDIT_TYPE_CD_MAL.equals(ordEditType)) {
			custBillMasterHistoryVO.setSysHistRem("[System] Change Mailing Address");
			custBillMasterHistoryVO.setAddrIdOld(Integer.parseInt((String) params.get("custAddIdOld")));
			custBillMasterHistoryVO.setAddrIdNw(Integer.parseInt((String) params.get("custAddId")));
			custBillMasterHistoryVO.setTypeId(1042);
		}
		else if(SalesConstants.ORDER_EDIT_TYPE_CD_CNT.equals(ordEditType)) {
			custBillMasterHistoryVO.setSysHistRem("[System] Change Contact Person");
			custBillMasterHistoryVO.setCntcIdOld(Integer.parseInt((String) params.get("custCntcId")));
			custBillMasterHistoryVO.setCntcIdNw(Integer.parseInt((String) params.get("custCntcIdOld")));
			custBillMasterHistoryVO.setTypeId(1043);
		}
	}
	
	@Override
	public EgovMap selectCustomerInfo(Map<String, Object> params) throws Exception {

		EgovMap outMap = orderModifyMapper.selectCustInfo(params);

		return outMap;
	}
	
	@Override
	public EgovMap selectInstallInfo(Map<String, Object> params) throws Exception {

		EgovMap instMap = orderDetailMapper.selectOrderInstallationInfoByOrderID(params);
		
		String TM = this.convert12Tm((String) instMap.get("preferInstTm"));
		
		instMap.put("preferInstTm", TM);
		
		return instMap;
	}
	
	private String convert12Tm(String TM) {
		String HH = "", MI = "", cvtTM = "";
		
		if(CommonUtils.isNotEmpty(TM)) {
			HH = CommonUtils.left(TM, 2);
			MI = TM.substring(3, 5);
			
			if(Integer.parseInt(HH) > 12) {
				cvtTM = String.valueOf(Integer.parseInt(HH) - 12) + ":" + String.valueOf(MI) + " PM";
			}
			else {
				cvtTM = HH + ":" + String.valueOf(MI) + " AM";
			}
		}
		return cvtTM;
	}
	
	private String convert24Tm(String TM) {
		String ampm = "", HH = "", MI = "", cvtTM = "";
		
		if(CommonUtils.isNotEmpty(TM)) {
			ampm = CommonUtils.right(TM, 2);
			HH = CommonUtils.left(TM, 2);
			MI = TM.substring(3, 5);
			
			if("PM".equals(ampm)) {
				cvtTM = String.valueOf(Integer.parseInt(HH) + 12) + ":" + MI + ":00";
			}
			else  {
				cvtTM = HH + ":" + MI + ":00";
			}
		}
		return cvtTM;
	}
	
	@Override
	public EgovMap selectInstallAddrInfo(Map<String, Object> params) throws Exception {

		EgovMap addrMap = customerMapper.selectCustomerViewMainAddress(params);

		return addrMap;
	}
	
	@Override
	public EgovMap selectInstallCntcInfo(Map<String, Object> params) throws Exception {

		EgovMap cnctMap = customerMapper.selectCustomerViewMainContact(params);
		
		return cnctMap;
	}
	
	@Override
	public EgovMap selectInstRsltCount(Map<String, Object> params) throws Exception {

		EgovMap cnctMap = orderModifyMapper.selectInstRsltCount(params);
		
		return cnctMap;
	}
	
	@Override
	public EgovMap selectGSTZRLocationCount(Map<String, Object> params) throws Exception {

		EgovMap cnctMap = orderModifyMapper.selectGSTZRLocationCount(params);
		
		return cnctMap;
	}
	
	@Override
	public EgovMap selectGSTZRLocationByAddrIdCount(Map<String, Object> params) throws Exception {

		EgovMap cnctMap = orderModifyMapper.selectGSTZRLocationByAddrIdCount(params);
		
		return cnctMap;
	}
	
	@Override
	public void updateInstallInfo(Map<String, Object> params, SessionVO sessionVO) throws ParseException {

		logger.info("!@###### OrderModifyServiceImpl.updateInstallInfo");

		params.put("updUserId", sessionVO.getUserId());
		params.put("preTm", this.convert24Tm((String) params.get("preTm")));

		orderModifyMapper.updateInstallInfo(params);

		orderModifyMapper.updateInstallUpdateInfo(params);
	}
	
	@Override
	public EgovMap selectRentPaySetInfo(Map<String, Object> params) throws Exception {

		EgovMap cnctMap = orderDetailMapper.selectOrderRentPaySetInfoByOrderID(params);
		
		return cnctMap;
	}
	
	@Override
	public List<EgovMap> selectReferralList(Map<String, Object> params) {
		return orderModifyMapper.selectReferralList(params);
	}
	
	@Override
	public List<EgovMap> selectStateCodeList(Map<String, Object> params) {
		return orderModifyMapper.selectStateCodeList(params);
	}
	
	@Override
	public void saveReferral(OrderModifyVO orderModifyVO, SessionVO sessionVO) throws Exception {

		GridDataSet<ReferralVO> gridReferralVOList  = orderModifyVO.getGridReferralVOList();
		
		List<ReferralVO> addList = gridReferralVOList.getAdd();
		List<ReferralVO> udtList = gridReferralVOList.getUpdate();

		for(ReferralVO addVO : addList) {
			
			if(CommonUtils.isEmpty(addVO.getRefCntc().trim())) {
				throw new ApplicationException(AppConstants.FAIL, "Please key-in Contact number.");
			}
			if(!CommonUtils.isNumCheck(addVO.getRefCntc().trim())) {
				throw new ApplicationException(AppConstants.FAIL, "Invalid Contact number.");
			}
			if(CommonUtils.intNvl(addVO.getRefStateId()) <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Please Select State.");
			}
			if(addVO.getRefCntc().trim().length() >= 12) {
				throw new ApplicationException(AppConstants.FAIL, "Contact number exceed valid digit.");
			}
			
			addVO.setSalesOrdId(orderModifyVO.getSalesOrdId());
			addVO.setCrtUserId(sessionVO.getUserId());
			addVO.setStusCode(1);
			
			orderModifyMapper.insertReferral(addVO);
		}
		
		for(ReferralVO udtVO : udtList) {
			
			if(CommonUtils.isEmpty(udtVO.getRefCntc().trim())) {
				throw new ApplicationException(AppConstants.FAIL, "Please key-in Contact number.");
			}
			if(!CommonUtils.isNumCheck(udtVO.getRefCntc().trim())) {
				throw new ApplicationException(AppConstants.FAIL, "Invalid Contact number.");
			}
			if(CommonUtils.intNvl(udtVO.getRefStateId()) <= 0) {
				throw new ApplicationException(AppConstants.FAIL, "Please Select State.");
			}
			if(udtVO.getRefCntc().trim().length() >= 12) {
				throw new ApplicationException(AppConstants.FAIL, "Contact number exceed valid digit.");
			}

			orderModifyMapper.updateReferral(udtVO);
		}
	}

	@Override
	public void updatePromoPriceInfo(SalesOrderMVO salesOrderMVO, SessionVO sessionVO) throws Exception {

		logger.info("!@###### OrderModifyServiceImpl.updatePromoPriceInfo");

		orderModifyMapper.updatePromoPriceInfo(salesOrderMVO);
	}

	@Override
	public void updateGSTEURCertificate(GSTEURCertificateVO gSTEURCertificateVO, SessionVO sessionVO) {

		logger.info("!@###### OrderModifyServiceImpl.updateGSTEURCertificate");

		this.preprocGSTCertificate(gSTEURCertificateVO, sessionVO);

		if("Y".equals(gSTEURCertificateVO.getExistData())) {
			orderModifyMapper.updateGSTEURCertificate(gSTEURCertificateVO); //UPDATE GST CERTIFICATE
		}
		else {
            orderRegisterMapper.insertGSTEURCertificate(gSTEURCertificateVO); //INSERT GST CERTIFICATE
		}
	}
	
	private void preprocGSTCertificate(GSTEURCertificateVO gSTEURCertificateVO, SessionVO sessionVO) {

		logger.info("!@###### preprocGSTCertificate START ");
		
		int reliefTypeId = 0;
		
		if(gSTEURCertificateVO.getEurcRliefAppTypeId() == SalesConstants.APP_TYPE_CODE_ID_RENTAL) {
			reliefTypeId = 1374; //Foreign Mission And International Organization
		}
		else if(gSTEURCertificateVO.getEurcRliefAppTypeId() == SalesConstants.APP_TYPE_CODE_ID_OUTRIGHT || gSTEURCertificateVO.getEurcRliefAppTypeId() == SalesConstants.APP_TYPE_CODE_ID_INSTALLMENT) {
			reliefTypeId = 1373; //Government Sector
		}
		
		gSTEURCertificateVO.setEurcRliefTypeId(reliefTypeId);
		gSTEURCertificateVO.setEurcStusCodeId(SalesConstants.STATUS_ACTIVE);
		gSTEURCertificateVO.setEurcCrtUserId(sessionVO.getUserId());
		gSTEURCertificateVO.setEurcUpdUserId(sessionVO.getUserId());
	}
	
}
