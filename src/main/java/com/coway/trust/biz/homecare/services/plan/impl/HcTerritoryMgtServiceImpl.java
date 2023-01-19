package com.coway.trust.biz.homecare.services.plan.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.homecare.services.plan.HcTerritoryMgtService;
import com.coway.trust.biz.organization.organization.TerritoryManagementService;
import com.coway.trust.biz.organization.organization.impl.MemberListMapper;
import com.coway.trust.biz.organization.organization.impl.TerritoryManagementMapper;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;
import com.coway.trust.web.homecare.HomecareConstants;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : HcTerritoryMgtServiceImpl.java
 * @Description : Homecare Territory Management ServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 13.   KR-SH        First creation
 * </pre>
 */
@Service("hcTerritoryMgtService")
public class HcTerritoryMgtServiceImpl extends EgovAbstractServiceImpl implements HcTerritoryMgtService {
	private static final Logger logger = LoggerFactory.getLogger(HcTerritoryMgtServiceImpl.class);

  	@Resource(name = "hcTerritoryMgtMapper")
  	private HcTerritoryMgtMapper hcTerritoryMgtMapper;

  	@Resource(name = "territoryManagementService")
  	private TerritoryManagementService territoryManagementService;

  	@Resource(name = "memberListMapper")
  	private MemberListMapper memberListMapper;

  	@Resource(name = "territoryManagementMapper")
  	private TerritoryManagementMapper territoryManagementMapper;

	/**
	 * select Homecare territoryList DetailList
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcTerritoryMgtService#selectHcTerritoryDetailList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectHcTerritoryDetailList(Map<String, Object> params) {
		return hcTerritoryMgtMapper.selectHcTerritoryDetailList(params);
	}

	/**
	 * Search Current Territory list
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcTerritoryMgtService#selectCurrentHcTerritory(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectCurrentHcTerritory(Map<String, Object> params) {
		return hcTerritoryMgtMapper.selectCurrentHcTerritory(params);
	}

	/**
	 * update TerritoryList
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcTerritoryMgtService#updateHcTerritoryList(java.util.Map)
	 */
	@Override
	public boolean updateHcTerritoryList(Map<String, Object> params) {
		int rtnCnt = 0;

		// HomeCare Delivery Canter 인경우.
		if(HomecareConstants.HDC_BRANCH_TYPE.equals(CommonUtils.nvl(params.get("brnchType")))) {
    		//reqstNo로 19M에 데이터를 다 가져옴
    		List<EgovMap> select19M = hcTerritoryMgtMapper.select19M(params);

    		//가져온값 64M에 UPDATE
    		if(select19M.size() > 0){
    			for(int i=0; i<select19M.size(); i++) {

    				if(params.get("memType").equals("5758")){
        				rtnCnt = hcTerritoryMgtMapper.updateSYS0064M(select19M.get(i));
    				}
    				if(params.get("memType").equals("6672")){
        				rtnCnt = hcTerritoryMgtMapper.updateSYS0064MLT(select19M.get(i));
    				}
    				//전에 썼던 것을 N으로 바꿔줘야된다(area_id로 이전 데이터가 쌓이니까
    				//area_id로 n을 주고 밑에서 area_id랑 reqstNo로 구분해 y로 바꿔주므로 n으로 바꿈)
    				rtnCnt += hcTerritoryMgtMapper.updateORG0019MFlag(select19M.get(i));
    				//19M에 AVAIL_FLAG 'Y'로 변경, CONFIRM STUS 4
    				rtnCnt += hcTerritoryMgtMapper.updateORG0019M(select19M.get(i));

    				if(rtnCnt != 3) {
    					throw new ApplicationException(AppConstants.FAIL, "Excel Update Failed.");
    				}
    			}
    		}
		}else if(HomecareConstants.DSC_BRANCH_TYPE.equals(CommonUtils.nvl(params.get("brnchType")))) {
    		//reqstNo로 19M에 데이터를 다 가져옴
    		List<EgovMap> select19M = hcTerritoryMgtMapper.select19M(params);

    		//가져온값 64M에 UPDATE
    		if(select19M.size() > 0){
    			for(int i=0; i<select19M.size(); i++) {

    				if(params.get("memType").equals("5758")){
        				rtnCnt = hcTerritoryMgtMapper.updateSYS0064M(select19M.get(i));
    				}
    				if(params.get("memType").equals("6672")){
        				rtnCnt = hcTerritoryMgtMapper.updateSYS0064MLT(select19M.get(i));
    				}
    				if(params.get("memType").equals("3")){
        				rtnCnt = hcTerritoryMgtMapper.updateSYS0064MAC(select19M.get(i));
    				}
    				//전에 썼던 것을 N으로 바꿔줘야된다(area_id로 이전 데이터가 쌓이니까
    				//area_id로 n을 주고 밑에서 area_id랑 reqstNo로 구분해 y로 바꿔주므로 n으로 바꿈)
    				rtnCnt += hcTerritoryMgtMapper.updateORG0019MFlag(select19M.get(i));
    				//19M에 AVAIL_FLAG 'Y'로 변경, CONFIRM STUS 4
    				rtnCnt += hcTerritoryMgtMapper.updateORG0019M(select19M.get(i));

    				if(rtnCnt != 3) {
    					throw new ApplicationException(AppConstants.FAIL, "Excel Update Failed.");
    				}
    			}
    		}
		}
		return true;
	}

	/**
	 * Insert Territory Management
	 * @Author KR-SH
	 * @Date 2019. 11. 13.
	 * @param params
	 * @param sessionVO
	 * @return
	 * @see com.coway.trust.biz.homecare.services.plan.HcTerritoryMgtService#excelUpload(java.util.Map, com.coway.trust.cmmn.model.SessionVO)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public EgovMap uploadExcel(Map<String, Object> params, SessionVO sessionVO) {
		EgovMap rtnMap = new EgovMap();
		int rtnCnt = 0;

		String bType = CommonUtils.nvl(params.get("comBranchTypep"));
		String memType = CommonUtils.nvl(params.get("comMemType"));
		List<TerritoryRawDataVO> vos = (ArrayList<TerritoryRawDataVO>) params.get("voList");

		EgovMap requestNo = territoryManagementService.getDocNo("156");
		String nextDocNo = territoryManagementService.getNextDocNo("TCR", CommonUtils.nvl(requestNo.get("docNo")));
		requestNo.put("nextDocNo", nextDocNo);
		memberListMapper.updateDocNo((Map<String, Object>)requestNo);

		List<Map<String, Object>> list = vos.stream().map(r -> {
			Map<String, Object> map = BeanConverter.toMap(r);
			map.put("brnchId", bType);
			map.put("reqstNo", requestNo.get("docNo"));
			map.put("requester", sessionVO.getUserId());
			return map;
		}).collect(Collectors.toList());

		int size = 1000;
		int page = list.size() / size;
		int start;
		int end;

		switch (bType) {
		case HomecareConstants.HDC_BRANCH_TYPE : // HDC Branch
			logger.debug("CASE_HDC./////" + bType);
			switch (memType) {
			case HomecareConstants.MEM_TYPE.DT :
				logger.debug("CASE_DT./////" + memType);
				Map<String, Object> hdcList = new HashMap<String, Object>();

				for (int i = 0; i <= page; i++) {
					start = i * size;
					end = size;

					if(i == page) {
						end = list.size();
					}
					hdcList.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));

					logger.debug("HDC LIST./////" + hdcList);
					rtnCnt = hcTerritoryMgtMapper.insertHDC(hdcList);
					logger.debug("HDC LIST11./////" + rtnCnt);
					if(rtnCnt <= 0) {
						throw new ApplicationException(AppConstants.FAIL, "Excel Update Failed.");
					}
				}

				rtnMap.put("isErr", false);
				rtnMap.put("errMsg", "upload success");

				break;

			case HomecareConstants.MEM_TYPE.LT :
				logger.debug("CASE_LT./////" + memType);
				Map<String, Object> LThdcList = new HashMap<String, Object>();

				for (int i = 0; i <= page; i++) {
					start = i * size;
					end = size;

					if(i == page) {
						end = list.size();
					}
					LThdcList.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));

					logger.debug("HDC LIST./////" + LThdcList);
					rtnCnt = hcTerritoryMgtMapper.insertHDCLT(LThdcList);
					logger.debug("HDC LIST./////" + rtnCnt);
					if(rtnCnt <= 0) {
						throw new ApplicationException(AppConstants.FAIL, "Excel Update Failed.");
					}
				}


				rtnMap.put("isErr", false);
				rtnMap.put("errMsg", "upload success");

				break;

			}
			break;
		case HomecareConstants.DSC_BRANCH_TYPE : // DSC Branch
			logger.debug("CASE_DSC./////" + bType);
			switch (memType) {
			case HomecareConstants.MEM_TYPE.CT :
				logger.debug("CASE_CT./////" + memType);
				Map<String, Object> hdcList = new HashMap<String, Object>();

				for (int i = 0; i <= page; i++) {
					start = i * size;
					end = size;

					if(i == page) {
						end = list.size();
					}
					hdcList.put("list", list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));

					logger.debug("DSC LIST./////" + hdcList);
					rtnCnt = hcTerritoryMgtMapper.insertDSC(hdcList);
					logger.debug("DSC LIST11./////" + rtnCnt);
					if(rtnCnt <= 0) {
						throw new ApplicationException(AppConstants.FAIL, "Excel Update Failed.");
					}
				}

				rtnMap.put("isErr", false);
				rtnMap.put("errMsg", "upload success");

				break;
			}
			break;
		default:
			rtnMap.put("isErr", true);
			rtnMap.put("errMsg", "Upload Failed - Null BranchType.");

			break;
		}

		return rtnMap;
	}

}
