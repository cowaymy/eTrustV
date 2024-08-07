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
	public EgovMap isReTestAlreadyResult(Map<String, Object> mp) {
		return UsedPartReTestResultMapper.isReTestAlreadyResult(mp);
	}

	@Override
	public int isReTestAlreadyResult_2(Map<String, Object> mp) {
		return UsedPartReTestResultMapper.isReTestAlreadyResult_2(mp);
	}

	@Override
	public EgovMap usedPartReTestResult_insert(Map<String, Object> params) {
	    LOGGER.debug("================usedPartReTestResult_insert - START ================");

	    Map svc0122dmap = (Map) params.get("upResultM");
	    svc0122dmap.put("updator", params.get("updator"));

	    params.put("DOCNO", "182");
	    EgovMap eMap = UsedPartReTestResultMapper.getUsedPartReTestResultDocNo(params);
	    EgovMap seqMap = UsedPartReTestResultMapper.getUsedPartReTestResultId(params); // GET NEXT SEQ FOR SVC0122D RESULT ID

	    String TEST_UP_ID = String.valueOf(seqMap.get("seq"));

	    LOGGER.debug("== NEW USED PART RETURN TEST RESULT ID = " + TEST_UP_ID);
	    LOGGER.debug("== NEW USED PART RETURN TEST RESULT NO = " + eMap.get("uprno"));

	    svc0122dmap.put("TEST_UP_ID", TEST_UP_ID);
	    svc0122dmap.put("TEST_UP_NO", String.valueOf(eMap.get("uprno")));

	    // INSERT SVC0122D RESULT
	    int c = this.insertSVC0122D(svc0122dmap);

	    LOGGER.debug("================usedPartReTestResult_insert - END ================");

	    EgovMap em = new EgovMap();
	    em.put("testResultNo", String.valueOf(eMap.get("uprno")));

	    return em;
	}

	public int insertSVC0122D(Map params) {
	    LOGGER.debug("== insertSVC0122D - START");
	    LOGGER.debug("== PARAMS {} ", params);

	    int a = UsedPartReTestResultMapper.insertSVC0122D(params);

	    LOGGER.debug("== insertSVC0122D - END");

	    return a;
	}

	@Override
	public EgovMap usedPartReTestResult_update(Map<String, Object> params) {
	    LOGGER.debug("================usedPartReTestResult_update - START ================");

	    Map svc0122dmap = (Map) params.get("upResultM");
	    svc0122dmap.put("updator", params.get("updator"));

	    LOGGER.debug("== EDIT USED PART RETURN TEST RESULT = " + svc0122dmap.get("TEST_RESULT_NO"));

	    // UPDATE SVC0122D RESULT
	    int c = this.updateSVC0122D(svc0122dmap);

	    LOGGER.debug("================usedPartReTestResult_update - END ================");

	    EgovMap em = new EgovMap();
	    em.put("testResultNo", String.valueOf(svc0122dmap.get("TEST_RESULT_NO")));

	    return em;
	}

	public int updateSVC0122D(Map params) {
	    LOGGER.debug("== updateSVC0122D - START");
	    LOGGER.debug("== PARAMS {} ", params);

	    int a = UsedPartReTestResultMapper.updateSVC0122D(params);

	    LOGGER.debug("== updateSVC0122D - END");

	    return a;
	}

	@Override
	public int usedPartNotTestedAdd(Map<String, Object> params) {
	    LOGGER.debug("== insertSVC0122D set to Not Tested - START");
	    LOGGER.debug("== PARAMS {} ", params);

	    params.put("DOCNO", "182");
	    ArrayList<String> serviceNo = (ArrayList<String>) params.get("serviceNo");
	    ArrayList<Integer> asrItmId = (ArrayList<Integer>) params.get("asrItmId");

	    int a = 0;

	    if(serviceNo.size() > 0){
	    	String asNo = null;
	    	int itmId = 0;

	    	for (int i=0; i< serviceNo.size() ; i++) {
	    		asNo =  serviceNo.get(i);
	    		itmId = asrItmId.get(i);

    		    LOGGER.debug("================map3================");
    			EgovMap eMap = UsedPartReTestResultMapper.getUsedPartReTestResultDocNo(params);
    		    EgovMap seqMap = UsedPartReTestResultMapper.getUsedPartReTestResultId(params); // GET NEXT SEQ FOR SVC0122D RESULT ID

    			String TEST_UP_ID = String.valueOf(seqMap.get("seq"));

    			LOGGER.debug("== NEW USED PART RETURN TEST RESULT ID (Set to Not Tested) = " + TEST_UP_ID);
    		    LOGGER.debug("== NEW USED PART RETURN TEST RESULT NO (Set to Not Tested)  = " + eMap.get("uprno"));

    			params.put("TEST_UP_ID", TEST_UP_ID);
    		    params.put("TEST_UP_NO", String.valueOf(eMap.get("uprno")));

    		    params.put("asNo", String.valueOf(asNo));
    		    params.put("asrItmId",itmId);

    			LOGGER.debug("== testing == " + params.toString());

    			a = UsedPartReTestResultMapper.insertSVC0122D_notTested(params);
    		}
	    }
	    LOGGER.debug("== insertSVC0122D set to Not Tested - END");

	    return a;
	}

	@Override
	public List<EgovMap> selectCTList(Map<String, Object> params) {
		return UsedPartReTestResultMapper.selectCTList(params);
	}

	@Override
	public List<EgovMap> getSpareFilterList(Map<String, Object> params) {
	    return UsedPartReTestResultMapper.getSpareFilterList(params);
	}

}
