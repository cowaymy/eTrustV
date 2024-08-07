package com.coway.trust.biz.sales.pst.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
import com.coway.trust.biz.sales.pst.PSTDealerService;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("pstDealerService")
public class PSTDealerServiceImpl  extends EgovAbstractServiceImpl implements PSTDealerService{

	private static final Logger logger = LoggerFactory.getLogger(PSTDealerServiceImpl.class);
	
	@Resource(name = "pstDealerMapper")
	private PSTDealerMapper pstDealerMapper;
	
	@Resource(name = "pstRequestDOMapper")
	private PSTRequestDOMapper pstRequestDOMapper;
	
	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param searchVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	public List<EgovMap> pstDealerList(Map<String, Object> params) {
		return  pstDealerMapper.pstDealerList(params);
	}
	
    public EgovMap pstDealerDtBasicInfo(Map<String, Object> params) {
    		return pstDealerMapper.pstDealerDtBasicInfo(params);
    }
    
    public EgovMap pstDealerDtUserInfo(Map<String, Object> params) {
		return pstDealerMapper.pstDealerDtUserInfo(params);
    }
    
    public List<EgovMap> pstDealerAddrComboList(Map<String, Object> params) {
    	logger.debug("==========params=========== :: " + params.toString());
    			//Country
    			if(params.get("country") == null && params.get("state") == null  && params.get("city") == null && params.get("postcode") == null){
    				params.put("colCountry", "1");
    			}
    			//State
    			if(params.get("country") != null && params.get("state") == null && params.get("city") == null && params.get("postcode") == null){
    				params.put("colState", "1");
    			}
    			//City
    			if(params.get("country") != null && params.get("state") != null  && params.get("city") == null && params.get("postcode") == null){
    				params.put("colCity", "1");
    			}
    			//Post Code
    			if(params.get("country") != null  && params.get("state") != null  && params.get("city") != null && params.get("postcode") == null){
    				params.put("colPostCode", "1");
    			}
    			//Area
    			if(params.get("country") != null  && params.get("state") != null  && params.get("city") != null && params.get("postcode") != null){
    				params.put("colArea", "1");
    			}
    			
		return  pstDealerMapper.pstDealerAddrComboList(params);
	}
    
    @Override
	public EgovMap getAreaId(Map<String, Object> params) {
    	return  pstDealerMapper.getAreaId(params);
    }
    
    public List<EgovMap> dealerBrnchList() {
		return  pstDealerMapper.dealerBrnchList();
	}
    
    public void newDealer(Map<String, Object> params) {
    	
    	int getUserIdSeq = pstDealerMapper.getUserIdSeq();
    	params.put("getUserIdSeq", getUserIdSeq);
    	params.put("userStatusID", 1);
    	params.put("userDeptID", 0);
    	params.put("userSyncCheck", 1);
    	params.put("userGsecSynCheck", 0);
    	params.put("userTypeID", 1161);
    	params.put("userValidTo", SalesConstants.DEFAULT_END_DATE);
    	params.put("userSecQuesID", 0);
    	params.put("userSecQuesAns", "");
    	params.put("userWorkNo", "");
    	params.put("userMobileNo", "");
    	params.put("userExtNo", "");
    	params.put("userIsPartTime", 0);
    	params.put("userDepartmentID", 0);
    	params.put("userIsExternal", 1);
    	pstDealerMapper.insertUserSYS0047M(params);
    	
    	int dealerIdSeq = pstDealerMapper.crtSeqSAL0030D();
    	params.put("dealerId", dealerIdSeq);
    	params.put("dealerStusId", 1);
    	params.put("dealerUserId", 0);
    	params.put("custId", 0);
    	pstDealerMapper.insertPstDealer(params);
    	
    	int getDealerAddId = pstRequestDOMapper.crtSeqSAL0031D();
    	params.put("getDealerAddId", getDealerAddId);
    	params.put("insDealerId", dealerIdSeq);
    	params.put("stusCodeId", 9);    	
    	pstRequestDOMapper.insertPstSAL0031D(params);
    	
    	int getDealerCntId = pstRequestDOMapper.crtSeqSAL0032D();
    	params.put("getDealerCntId", getDealerCntId);
    	params.put("cntcInitial", params.get("cmbInitialTypeId"));
    	params.put("cntcCmbRaceTypeId", params.get("cmbRaceTypeId"));
    	pstRequestDOMapper.insertPstSAL0032D(params);
    	
    	params.put("roleID", 148);
    	params.put("statusID", 1);
    	params.put("userID", getUserIdSeq);
    	memberListMapper.insertRoleUser(params);
    	
    }
    
    public void editDealer(Map<String, Object> params) {
    	pstDealerMapper.updDealerSAL0030D(params);
    }
    
    public void updDealerCntSAL0032D(Map<String, Object> params) {
    	pstDealerMapper.updDealerCntSAL0032D(params);
    }
}
