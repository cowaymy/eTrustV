/**
 *
 */
package com.coway.trust.biz.homecare.po.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.po.HcPoIssueService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Jin
 *
 */
@Service("hcPoIssueService")
public class HcPoIssueServiceImpl extends EgovAbstractServiceImpl implements HcPoIssueService {

	//private static Logger logger = LoggerFactory.getLogger(HcPoIssueServiceImpl.class);

	@Resource(name = "hcPoIssueMapper")
	private HcPoIssueMapper hcPoIssueMapper;


	@Override
	public List<EgovMap> selectCdcList() throws Exception {
		return hcPoIssueMapper.selectCdcList();
	}

	@Override
	public int selectHcPoIssueMainListCnt(Map<String, Object> params) throws Exception{
		return hcPoIssueMapper.selectHcPoIssueMainListCnt(params);
	}

	@Override
	public List<EgovMap> selectHcPoIssueMainList(Map<String, Object> params) throws Exception{
		return hcPoIssueMapper.selectHcPoIssueMainList(params);
	}

	@Override
	public List<EgovMap> selectHcPoIssueSubList(Map<String, Object> params) throws Exception{
		return hcPoIssueMapper.selectHcPoIssueSubList(params);
	}

	@Override
	public int multiHcPoIssue(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		int saveCnt = 0;
		String poNo = "";

		List<Object> mainList = (List<Object>)params.get("mainData");
		Map<String, Object> mainMap = null;
		for (Object obj : mainList) {
			mainMap = (Map<String, Object>) obj;
			mainMap.put("crtUserId", sessionVO.getUserId());
			mainMap.put("updUserId", sessionVO.getUserId());
			mainMap.put("poStsCd", "10");    // 5607:10:Pending (429)
			//mainMap.put("suppStsCd", "10");  // 5693:10:Pending (438)

			if( StringUtils.isBlank((String)mainMap.get("poNo"))){
				hcPoIssueMapper.insertHcPoIssueMain(mainMap);
			}else{
				hcPoIssueMapper.updateHcPoIssueMain(mainMap);
			}
			poNo = (String)mainMap.get("poNo");
			saveCnt++;
		}

		List<Object> addList = params.get(AppConstants.AUIGRID_ADD); 	// Get grid addList
		List<Object> udtList = params.get(AppConstants.AUIGRID_UPDATE); // Get grid UpdateList
		List<Object> dltList = params.get(AppConstants.AUIGRID_REMOVE); // Get grid DeleteList

		Map<String, Object> map = null;
		for (Object obj : addList) {
			map = (Map<String, Object>) obj;
			map.put("poNo", poNo);
			map.put("crtUserId", sessionVO.getUserId());
			map.put("updUserId", sessionVO.getUserId());

			hcPoIssueMapper.insertHcPoIssueSub(map);
		}

		map = null;
		for (Object obj : udtList) {
			map = (Map<String, Object>) obj;
			map.put("crtUserId", sessionVO.getUserId());
			map.put("updUserId", sessionVO.getUserId());
			if(StringUtils.isBlank((String)map.get("poNo"))){
				map.put("poNo", poNo);
				hcPoIssueMapper.insertHcPoIssueSub(map);
			}else{
				hcPoIssueMapper.updateHcPoIssueSub(map);
			}
		}

		map = null;
		for (Object obj : dltList) {
			map = (Map<String, Object>) obj;
			map.put("updUserId", sessionVO.getUserId());
			hcPoIssueMapper.deleteHcPoIssueSub(map);
		}

		// detail Key re-sort
		Map<String, String> sortMap = new HashMap<String, String>();
		sortMap.put("sPoNo", poNo);
		hcPoIssueMapper.updateHCPoDetailKeySort(sortMap);


		List<Object> deleteList = (List<Object>)params.get("removeData");
		Map<String, Object> delMap = null;
		for (Object obj : deleteList) {
			delMap = (Map<String, Object>) obj;
			delMap.put("updUserId", sessionVO.getUserId());

			Map<String, Object> sMap = new HashMap<String, Object>();
			sMap.put("sPoNo", delMap.get("poNo"));
			List<EgovMap> sList = hcPoIssueMapper.selectHcPoIssueMainList(sMap);
			if(sList != null && sList.size() > 0){
				if( !"10".equals( (String)((Map<String, Object>)sList.get(0)).get("poStsCode")) ){
					throw new ApplicationException(AppConstants.FAIL, "You cannot delete it. <br /> Please search again.");
				}
			}

			hcPoIssueMapper.deleteHcPoIssuePoSub(delMap);
			hcPoIssueMapper.deleteHcPoIssuePoMain(delMap);
		}

		return saveCnt;
	}

	@Override
	public int multiIssueHcPoIssue(Map<String, ArrayList<Object>> params, SessionVO sessionVO) throws Exception{
		int cnt = 1;

		multiHcPoIssue(params, sessionVO);
		List<Object> mainList = (List<Object>)params.get("mainData");
		String poNo = (String) ((Map<String, Object>) mainList.get(0)).get("poNo");

		List<String> rsnList = (List)params.get("rsnList");	// issueRsn

		Map<String, Object> issueMap = new HashMap<String, Object>();
		issueMap.put("poNo", poNo);
		issueMap.put("poStsCd", "20"); 	// 5608:20:Requested
		issueMap.put("issueRsn", rsnList.get(0));
		issueMap.put("updUserId", sessionVO.getUserId());
		hcPoIssueMapper.updateIssueHcPoIssue(issueMap);

		return cnt;
	}

	@Override
	public int multiApprovalHcPoIssue(Map<String, Object> params, SessionVO sessionVO) throws Exception{
		int cnt = 1;

		if("approve".equals(params.get("gubun"))){
			params.put("poStsCd", "30"); 	// 5609:30:Approval
			params.put("suppStsCd", "10");  // 5693:10:Pending (438)
		}else{
			params.put("poStsCd", "39"); 	// 5610:39:Reject
		}
		params.put("updUserId", sessionVO.getUserId());
		hcPoIssueMapper.updateApprovalHcPoIssue(params);
		return cnt;
	}

}
