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
import com.coway.trust.biz.sales.order.vo.OrderVO;
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
import com.coway.trust.biz.sales.promotion.vo.SalesPromoMVO;
import com.coway.trust.biz.sales.pst.impl.PSTRequestDOServiceImpl;
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
		
		logger.info("!@###### billGrpOrd.size():"+billGrpOrd.size());

		billGrpInfo.put("totOrder", billGrpOrd.size());
		
		params.put("custCntcId", billGrpInfo.get("custBillCntId"));
		
		logger.info("!@###### custBillCustId:"+billGrpInfo.get("custBillCustId"));
		
		EgovMap custAddInfo = customerMapper.selectCustomerViewMainContact(params);
		
		custAddInfo.put("code",	CommonUtils.isEmpty(custAddInfo.get("code")) ? "" : custAddInfo.get("code"));
		custAddInfo.put("name1",	CommonUtils.isEmpty(custAddInfo.get("name1")) ? "" : custAddInfo.get("name1"));
		
		billGrpInfo.put("custAddInfo", custAddInfo);
		
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

		return instMap;
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
	

}
