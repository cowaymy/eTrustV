package com.coway.trust.biz.organization.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.LMSApiService;
import com.coway.trust.biz.common.CommonService;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.login.SsoLoginService;
import com.coway.trust.biz.organization.organization.MemberAccessService;
import com.coway.trust.web.organization.organization.MemberAccessController;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memberAccessService")

public class MemberAccessServiceImpl extends EgovAbstractServiceImpl implements MemberAccessService{

	private static final Logger LOGGER = LoggerFactory.getLogger(MemberAccessServiceImpl.class);

	@Resource(name = "commonService")
	private CommonService commonService;

	@Resource(name = "memberAccessMapper")
	private MemberAccessMapper memberAccessMapper;

	@Resource(name = "commonApiService")
	  private CommonApiService commonApiService;

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	@Autowired
    private LMSApiService lmsApiService;

	@Resource(name = "ssoLoginService")
	  private SsoLoginService ssoLoginService;
	/*@Value("${lms.api.username}")
	private String LMSApiUser;

	@Value("${lms.api.password}")
	private String LMSApiPassword;*/

	//private SessionHandler sessionHandler;
	/**
	 * search Organization Gruop List
	 *
	 * @param Map
	 * @return
	 * @exception Exception
	 */
	@Override

	public List<EgovMap> selectPosition(Map<String, Object> params) {
		return memberAccessMapper.selectPosition(params);
	}

	@Override
    public EgovMap getOrgDtls(Map<String, Object> params) {
        return memberAccessMapper.getOrgDtls(params);
    }

	public List<EgovMap> selectMemberAccessList(Map<String, Object> params) {
		return memberAccessMapper.selectMemberAccessList(params);
	}

	@Override
	public EgovMap selectMemberAccessListView(String memberID) {
		return memberAccessMapper.selectMemberAccessListView(memberID);
	}

	@Override
    public int checkExistRequest(String memCode) {
        return memberAccessMapper.checkExistRequest(memCode);
    }

	@Override
	public String getFinApprover() throws Exception{
		return memberAccessMapper.getFinApprover();
	}

	@Override
	public List<EgovMap> accessApprovalList(Map<String, Object> p) {
		return memberAccessMapper.accessApprovalList(p);
	}

	@Override
	public int checkExistMemCode(Map<String, Object> params) {

		HashMap<String, Object> mp = new HashMap<String, Object>();
	    //Map<?, ?> svc0004dmap = (Map<?, ?>) params.get("requestResultM");
	    params.put("memCode", params.get("memCode"));
		return memberAccessMapper.checkExistMemCode(params);
	}

	@Override
	public String selectNextRequestID() {
		// TODO Auto-generated method stub
		return memberAccessMapper.selectNextRequestID();
	}

	@Override
	public void insertApproveManagement(Map<String, Object> params) {
		// TODO Auto-generated method stub
		LOGGER.debug("params =====================================>>  " + params);

		List<Object> apprGridList = (List<Object>) params.get("apprGridList");
		HashMap<String, Object> mp = new HashMap<String, Object>();
	    Map<?, ?> detailmap = (Map<?, ?>) params.get("requestResultM");

		params.put("appvLineCnt", apprGridList.size());
		params.put("requestCategory", detailmap.get("requestCategory"));
		params.put("memCode", detailmap.get("memCode"));
		params.put("caseCategory", detailmap.get("caseCategory"));
		params.put("remark1", detailmap.get("remark1"));
		params.put("effectDt", detailmap.get("effectDt"));
		params.put("userName", detailmap.get("userName"));


		LOGGER.debug("mp params =====================================>>  " + mp);
		LOGGER.debug("detailmap params =====================================>>  " + detailmap);
		LOGGER.debug("insertApproveManagement =====================================>>  " + params);
		memberAccessMapper.insertApproveMaster(params);

		if (apprGridList.size() > 0) {
			Map hm = null;

			for (Object map : apprGridList) {
				hm = (HashMap<String, Object>) map;
				hm.put("requestID", params.get("requestID"));
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveLineDetail =====================================>>  " + hm);
				// TODO appvLineDetailTable Insert
				memberAccessMapper.insertApproveLineDetail(hm);
			}
		}

		if (detailmap.size() > 0) {
			Map hm = null;

			LOGGER.debug("insertRequestMaster!!!!");

			// biz처리
			/*for (Object map : requestResultM) {
				hm = (HashMap<String, Object>) map;
				hm.put("requestID", params.get("requestID"));
				//int appvItmSeq = webInvoiceMapper.selectNextAppvItmSeq(String.valueOf(params.get("appvPrcssNo")));
				//hm.put("appvItmSeq", appvItmSeq);
				hm.put("userId", params.get("userId"));
				hm.put("userName", params.get("userName"));
				LOGGER.debug("insertApproveItems =====================================>>  " + hm);
				// TODO appvLineItemsTable Insert
				//staffClaimMapper.insertApproveItems(hm);
			}*/
		}

		LOGGER.debug("updateAppvPrcssNo =====================================>>  " + params);
		// TODO pettyCashReqst table update
		/*staffClaimMapper.updateAppvPrcssNo(params);*/
	}

	@Override
	public void updateApproval(Map<String, Object> p) {
		memberAccessMapper.updateApproval(p);
	}

	@Override
	public int updateAccess(Map<String, Object> p) {
		LOGGER.debug("updateAccess =====================================>>  " + p);
		return memberAccessMapper.updateAccess(p);
	}

}
