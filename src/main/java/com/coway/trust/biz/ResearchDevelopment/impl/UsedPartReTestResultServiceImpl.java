package com.coway.trust.biz.ResearchDevelopment.impl;

import java.math.BigDecimal;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.ResearchDevelopment.UsedPartReTestResultService;
import com.coway.trust.biz.sales.customer.impl.CustomerServiceImpl;
import com.coway.trust.biz.sales.mambership.impl.MembershipRentalQuotationMapper;
import com.coway.trust.biz.sales.pos.impl.PosMapper;
import com.coway.trust.biz.services.as.ASManagementListService;
import com.coway.trust.biz.services.as.impl.ASManagementListMapper;
import com.coway.trust.biz.services.as.impl.ASManagementListServiceImpl;
import com.coway.trust.biz.services.as.impl.AsResultChargesViewVO;
import com.coway.trust.biz.services.as.impl.ServicesLogisticsPFCMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.ReturnMessage;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import oracle.sql.DATE;

@Service("UsedPartReTestResultService")
public class UsedPartReTestResultServiceImpl extends EgovAbstractServiceImpl implements UsedPartReTestResultService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UsedPartReTestResultServiceImpl.class);

	@Resource(name = "UsedPartReTestResultMapper")
	  private UsedPartReTestResultMapper UsedPartReTestResultMapper;

	 @Resource(name = "ASManagementListMapper")
	  private ASManagementListMapper ASManagementListMapper;

	  @Override
	  public List<EgovMap> selectUsedPartReList(Map<String, Object> params) {
	    return UsedPartReTestResultMapper.selectUsedPartReList(params);
	  }

	  @Override
	  public List<EgovMap> getASRulstSVC0004DInfo(Map<String, Object> params) {
	    return UsedPartReTestResultMapper.getASRulstSVC0004DInfo(params);
	  }

	  @Override
	  public List<EgovMap> getTestResultInfo(Map<String, Object> params) {
	    return UsedPartReTestResultMapper.getTestResultInfo(params);
	  }

	  @Override
	  public EgovMap selectOrderBasicInfo(Map<String, Object> params) {
	    return ASManagementListMapper.selectOrderBasicInfo(params);
	  }

	  /**
	   * SVC0004D insert
	   *
	   * @param params
	   * @return
	   */
	  public int insertSVC0004D(Map<String, Object> params) {
	    LOGGER.debug("== insertSVC0004D - START");
	    LOGGER.debug("== PARAMS {} ", params);

	    int a = ASManagementListMapper.insertSVC0004D(params);

	    LOGGER.debug("== insertSVC0004D - END");

	    return a;
	  }

	  @Override
	  public EgovMap getAsEventInfo(Map<String, Object> params) {
	    // TODO Auto-generated method stub
	    return ASManagementListMapper.getAsEventInfo(params);
	  }

	  @Override
	  public String getSearchDtRange() {
	    return ASManagementListMapper.getSearchDtRange();
	  }

	  @Override
	  public List<EgovMap> asProd() {
	    return UsedPartReTestResultMapper.asProd();
	  }

	  @Override
	  public List<EgovMap> selectAsCrtStat() {
	    return UsedPartReTestResultMapper.selectAsCrtStat();
	  }

	  @Override
	  public List<EgovMap> selectTimePick() {
	    return UsedPartReTestResultMapper.selectTimePick();
	  }

	@Override
	public int isReTestAlreadyResult(HashMap<String, Object> mp) {
		return UsedPartReTestResultMapper.isReTestAlreadyResult(mp);
	}

	@Override
	public EgovMap usedPartReTestResult_insert(Map<String, Object> params) {
	    LOGGER.debug("================usedPartReTestResult_insert - START ================");

	    String m = "";
	    Map svc0004dmap = (Map) params.get("asResultM");
	    svc0004dmap.put("updator", params.get("updator"));

	    Map tm = new HashMap();
	    tm.put("srvSalesOrderId", svc0004dmap.get("AS_SO_ID"));

	    //params.put("DOCNO", "21"); -- //confirm prefix and doc_no to use
	    //EgovMap eMap = UsedPartReTestResultMapper.getASEntryDocNo(params);
	    //EgovMap seqMap = UsedPartReTestResultMapper.getResultASEntryId(params); // GET NEXT SEQ FOR SVC0122D RESULT ID

	    //String AS_RESULT_ID = String.valueOf(seqMap.get("seq"));

	    //LOGGER.debug("== NEW USED PART RETURN TEST RESULT ID = " + AS_RESULT_ID);
	    //LOGGER.debug("== NEW USED PART RETURN TEST RESULT NO = " + eMap.get("asno"));

	    //svc0004dmap.put("AS_RESULT_ID", AS_RESULT_ID);
	    //svc0004dmap.put("AS_RESULT_NO", String.valueOf(eMap.get("asno")));

	    // INSERT SVC0122D RESULT
	    int c = this.insertSVC0122D(svc0004dmap);

	    svc0004dmap.put("AS_ID", svc0004dmap.get("AS_ENTRY_ID"));
	    svc0004dmap.put("USER_ID", String.valueOf(svc0004dmap.get("updator")));

	    LOGGER.debug("================usedPartReTestResult_insert - END ================");

	    EgovMap em = new EgovMap();
	    //em.put("AS_NO", String.valueOf(eMap.get("asno")));

	    return em;
	}

	private int insertSVC0122D(Map svc0004dmap) {
		// TODO Auto-generated method stub
		return 0;
	}

}
