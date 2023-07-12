package com.coway.trust.biz.organization.organization.impl;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.organization.organization.HpAwardHistoryService;
import com.coway.trust.web.organization.organization.HpAwardHistoryController;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("HpAwardHistoryService")
public class HpAwardHistoryServiceImpl implements HpAwardHistoryService{

	private static final Logger LOGGER = LoggerFactory.getLogger(HpAwardHistoryServiceImpl.class);

	@Resource(name = "HpAwardHistoryMapper")
	private HpAwardHistoryMapper hpAwardHistoryMapper;

	@Override
	public List <EgovMap> selectHpAwardHistoryListing(Map<String, Object> params){
		return hpAwardHistoryMapper.selectHpAwardHistoryListing(params);
	}

	@Override
	public List <EgovMap> selectHpAwardHistoryDetails(Map<String, Object> params){
		return hpAwardHistoryMapper.selectHpAwardHistoryDetails(params);
	}

	@Override
	public List <EgovMap> selectIncentiveCode(Map<String, Object> params){
		return hpAwardHistoryMapper.selectIncentiveCode(params);
	}

	@Override
	public List <EgovMap> selectEachHpAwardHistory(Map<String, Object> params){
		return hpAwardHistoryMapper.selectEachHpAwardHistory(params);
	}

	@Override
	public List <EgovMap> selectHpAwardHistoryReport(Map<String, Object> params){
		return hpAwardHistoryMapper.selectHpAwardHistoryReport(params);
	}

	@Override
	public List <EgovMap> selectYearList(Map<String, Object> params){
		return hpAwardHistoryMapper.selectYearList(params);
	}

	@Override
	public List <EgovMap> selectMonthList(Map<String, Object> params){
		return hpAwardHistoryMapper.selectMonthList(params);
	}

	@Override
	public int insertHpAwardHistoryMaster(Map<String, Object>params){
		return hpAwardHistoryMapper.insertHpAwardHistoryMaster(params);
	}

	@Override
	public int insertHpAwardHistoryDetails(Map<String, Object>params){
		return hpAwardHistoryMapper.insertHpAwardHistoryDetails(params);
	}

	@Override
	public int updateHpAwardHistoryStatus(Map<String, Object>params){
		return hpAwardHistoryMapper.updateHpAwardHistoryStatus(params);
	}

	@Override
	public int updateHpAwardHistoryDetails(Map<String, Object>params){

		int detailsResult = 0;

		for(Object details : (List<Object>) params.get("addList")){
			Map<String, Object> addData = (Map<String,Object>) details;
			addData.put("userId", params.get("userId"));
			detailsResult = hpAwardHistoryMapper.updateNewHpAwardHistoryDetails(addData);
		}

		for(Object editDetails : (List<Object>) params.get("editList")){
			Map<String, Object> editData = (Map<String,Object>) editDetails;
			editData.put("userId", params.get("userId"));
			detailsResult = hpAwardHistoryMapper.updateHpAwardHistoryDetails(editData);
		}

		return detailsResult;
	}

	@Override
	public Map<String, Object> updateIncentiveCode(Map<String, Object>params){

		Map<String, Object> response = new HashMap<String, Object>();

		try{

			for(Map<String, Object> removeData : (List<Map<String, Object>>) params.get("removeList")){
				removeData.put("userId", params.get("userId"));
				hpAwardHistoryMapper.updateIncentiveCode(removeData);
			}

			for(Map<String, Object> addData : (List<Map<String, Object>>) params.get("addList")){

				if(!hpAwardHistoryMapper.chkIncentiveCodeDup(addData).get("chkDup").equals(BigDecimal.ZERO)){
					response.put("success", 0);
					response.put("msg", "This Incentive Code " + addData.get("incentiveCode").toString() + " has been registered or duplicated. Please use another or deactivate it.");
					return  response;
				}

				addData.put("userId", params.get("userId"));
				boolean bool = (hpAwardHistoryMapper.updateNewIncentiveCode(addData) == 0);

				if(bool){
					response.put("success", 0);
					response.put("msg", "This Incentive Code" + addData.get("incentiveCode").toString() + " unable to register. Kindly please raise ticket and with IT Dept.");
					return response;
				}
			}

			for(Map<String, Object> editData :  (List<Map<String, Object>>) params.get("editList")){

				editData.put("userId", params.get("userId"));

				if(!hpAwardHistoryMapper.chkIncentiveCodeDup(editData).get("chkDup").equals(BigDecimal.ZERO)){
					response.put("success", 0);
					response.put("msg", "This Incentive Code " + editData.get("incentiveCode").toString() + " has been registered or duplicated. Please use another or deactivate it.");
					return  response;
				}

				boolean bool = (hpAwardHistoryMapper.updateIncentiveCode(editData) == 0);

				if(bool){
					response.put("success", 0);
					response.put("msg", "This Incentive Code " + editData.get("incentiveCode").toString() + " unable to update. Kindly please raise ticket and with IT Dept.");
					return response;
				}
			}

			response.put("success", 1);
			response.put("msg", "Success to save.");
			return response;

		}catch(Throwable e){
			response.put("success", -1);
			response.put("msg", e);
			return response;
		}
	}

}