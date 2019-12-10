package com.coway.trust.biz.organization.organization.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import com.coway.trust.util.BeanConverter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.biz.organization.organization.TerritoryManagementService;
import com.coway.trust.cmmn.model.SessionVO;
import com.coway.trust.web.organization.organization.excel.TerritoryRawDataVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("territoryManagementService")
public class TerritoryManagementServiceImpl extends EgovAbstractServiceImpl implements TerritoryManagementService{
	private static final Logger logger = LoggerFactory.getLogger(TerritoryManagementService.class);

	@Resource(name = "territoryManagementMapper")
	private TerritoryManagementMapper territoryManagementMapper;

	@Resource(name = "memberListMapper")
	private MemberListMapper memberListMapper;

	@Override
	public List<EgovMap> selectList(Map<String, Object> params) {
		return territoryManagementMapper.selectList(params);
	}

	@Override
	public List<EgovMap> selectTerritory(Map<String, Object> params) {
		return territoryManagementMapper.selectTerritory(params);
	}

	@Override
	public List<EgovMap> selectMagicAddress(Map<String, Object> params) {
		return territoryManagementMapper.selectMagicAddress(params);
	}

	@Override
	public EgovMap uploadVaild(Map<String, Object> params, SessionVO sessionVO) {

		String bType = (String) params.get("comBranchTypep");
		List<TerritoryRawDataVO> vos = (List) params.get("voList");

		EgovMap rtnMap = new EgovMap();

		EgovMap requestNo = getDocNo("156");
		String nextDocNo = getNextDocNo("TCR", requestNo.get("docNo").toString());
		requestNo.put("nextDocNo", nextDocNo);
		memberListMapper.updateDocNo(requestNo);

		List<Map> list = vos.stream().map(r -> {
			Map<String, Object> map = BeanConverter.toMap(r);
			map.put("brnchId", bType);
			map.put("reqstNo", requestNo.get("docNo"));
			map.put("requester", sessionVO.getUserId());
			return map;
		})	.collect(Collectors.toList());

		int size = 1000;
		int page = list.size() / size;
		int start;
		int end;

		switch (bType) {
		case "42": // Cody Branch
			Map<String, Object> list42 = new HashMap<>();

			for (int i = 0; i <= page; i++) {
				start = i * size;
				end = size;

				if(i == page){
					end = list.size();
				}

				list42.put("list",
						list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
				territoryManagementMapper.insertCody(list42);
			}

			break;
		case "43": // Dream Service Center

			Map<String, Object> list43 = new HashMap<>();

			for (int i = 0; i <= page; i++) {
				start = i * size;
				end = size;

				if(i == page){
					end = list.size();
				}

				list43.put("list",
						list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
				territoryManagementMapper.insertDreamServiceCenter(list43);
			}
			break;
		case "45": // Sales Office

			Map<String, Object> list45 = new HashMap<>();

			for (int i = 0; i <= page; i++) {
				start = i * size;
				end = size;

				if(i == page){
					end = list.size();
				}

				list45.put("list",
						list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
				territoryManagementMapper.insertSalesOffice(list45);
			}
			break;
		case "48": // Homecare Technician

			Map<String, Object> list48 = new HashMap<>();

			for (int i = 0; i <= page; i++) {
				start = i * size;
				end = size;

				if(i == page){
					end = list.size();
				}

				list48.put("list",
						list.stream().skip(start).limit(end).collect(Collectors.toCollection(ArrayList::new)));
				territoryManagementMapper.insertHomecareTechnician(list48);
			}
			break;
		default:
			logger.info("Unknown type...... bType : {}", bType);
			break;
		}



		/*
		Map<String, Object> q = new HashMap<>();
		int i =0;
		for (TerritoryRawDataVO vo : vos) {
			logger.debug("i : {}", i);
			i++;

			q.put("areaId", vo.getAreaId());
			q.put("branch", vo.getBranch());
			q.put("extBranch", vo.getExtBranch());
			q.put("brnchId", bType);
			q.put("reqstNo", requestNo.get("docNo"));
			q.put("requester", sessionVO.getUserId());

			switch (bType) {
			case "42": // Cody Branch
				territoryManagementMapper.insertCody(q);
				break;
			case "43": // Dream Service Center
				territoryManagementMapper.insertDreamServiceCenter(q);
				break;
			default:
				logger.info("Unknown type...... bType : {}", bType);
				break;
			}
		}
		*/

		rtnMap.put("isErr", false);
		rtnMap.put("errMsg", "upload success");

		return rtnMap;

		// return territoryManagementMapper.selectList();
	}

	@Transactional
	@Override
	public boolean updateMagicAddressCode(Map<String, Object> params) {
		boolean success=false;
		if(params.get("brnchType").toString().equals("42")){
    		//reqstNo로 19M에 데이터를 다 가져옴
    		List<EgovMap> select19M = territoryManagementMapper.select19M(params);
    		logger.debug("select19M {}", select19M);
    		//가져온값 64M에 UPDATE
    		if(select19M.size() > 0){
    			for(int i=0; i<select19M.size(); i++){
    				territoryManagementMapper.updateSYS0064M(select19M.get(i));
    				//전에 썼던 것을 N으로 바꿔줘야된다(area_id로 이전 데이터가 쌓이니까
    				//area_id로 n을 주고 밑에서 area_id랑 reqstNo로 구분해 y로 바꿔주므로 n으로 바꿈)
    				territoryManagementMapper.updateORG0019MFlag(select19M.get(i));
    				//19M에 AVAIL_FLAG 'Y'로 변경, CONFIRM STUS 4
    				territoryManagementMapper.updateORG0019M(select19M.get(i));
    			}

    		}

		}else if(params.get("brnchType").toString().equals("45")){
    		List<EgovMap> select19M = territoryManagementMapper.select19M(params);
    		logger.debug("select19M {}", select19M);
    		if(select19M.size() > 0){
    			for(int i=0; i<select19M.size(); i++){
    				territoryManagementMapper.updateSYS0064MSO(select19M.get(i));
    				territoryManagementMapper.updateORG0019MFlag(select19M.get(i));
    				territoryManagementMapper.updateORG0019M(select19M.get(i));
    			}
    		}
		}else if(params.get("brnchType").toString().equals("48")){
    		List<EgovMap> select19M = territoryManagementMapper.select19M(params);
    		logger.debug("select19M {}", select19M);
    		if(select19M.size() > 0){
    			for(int i=0; i<select19M.size(); i++){
    				territoryManagementMapper.updateSYS0064MHT(select19M.get(i));
    				territoryManagementMapper.updateORG0019MFlag(select19M.get(i));
    				territoryManagementMapper.updateORG0019M(select19M.get(i));
    			}
    		}
		}else{
			//reqstNo로 19M에 데이터를 다 가져옴
    		List<EgovMap> select19M = territoryManagementMapper.select19M(params);
    		logger.debug("select19M {}", select19M);
    		//가져온값 64M에 UPDATE
    		if(select19M.size() > 0){
    			for(int i=0; i<select19M.size(); i++){
    				territoryManagementMapper.updateSYS0064MDream(select19M.get(i));
    				//전에 썼던 것을 N으로 바꿔줘야된다(area_id로 이전 데이터가 쌓이니까
    				//area_id로 n을 주고 밑에서 area_id랑 reqstNo로 구분해 y로 바꿔주므로 n으로 바꿈)
    				territoryManagementMapper.updateORG0019MFlag(select19M.get(i));
    				//19M에 AVAIL_FLAG 'Y'로 변경, CONFIRM STUS 4
    				territoryManagementMapper.updateORG0019M(select19M.get(i));
    			}

    		}

		}
		return true;
	}

	@Override
	public EgovMap getDocNo(String docNoId){
		int tmp = Integer.parseInt(docNoId);
		String docNo = "";
		EgovMap selectDocNo = memberListMapper.selectDocNo(docNoId);
		logger.debug("selectDocNo : {}",selectDocNo);
		String prefix = "";

		if(Integer.parseInt((String) selectDocNo.get("docNoId").toString()) == tmp){

			if(selectDocNo.get("c2") != null){
				prefix = (String) selectDocNo.get("c2");
			}else{
				prefix = "";
			}
			docNo = prefix.trim()+(String) selectDocNo.get("c1");
			//prefix = (selectDocNo.get("c2")).toString();
			logger.debug("prefix : {}",prefix);
			selectDocNo.put("docNo", docNo);
			selectDocNo.put("prefix", prefix);
		}
		return selectDocNo;
	}

	@Override
	public String getNextDocNo(String prefixNo,String docNo){
		String nextDocNo = "";
		int docNoLength=0;
		System.out.println("!!!"+prefixNo);
		if(prefixNo != null && prefixNo != ""){
			docNoLength = docNo.replace(prefixNo, "").length();
			docNo = docNo.replace(prefixNo, "");
		}else{
			docNoLength = docNo.length();
		}

		int nextNo = Integer.parseInt(docNo) + 1;
		nextDocNo = String.format("%0"+docNoLength+"d", nextNo);
		logger.debug("nextDocNo : {}",nextDocNo);
		return nextDocNo;
	}

	@Override
	public List<EgovMap> selectBranchCode(Map<String, Object> params) {
		return territoryManagementMapper.selectBranchCode(params);
	}

	@Override
	public List<EgovMap> selectState(Map<String, Object> params) {
		return territoryManagementMapper.selectState(params);
	}

	@Override
	public List<EgovMap> selectCurrentTerritory(Map<String, Object> params) {
		return territoryManagementMapper.selectCurrentTerritory(params);
	}
}
