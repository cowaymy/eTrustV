package com.coway.trust.biz.logistics.adjustment.impl;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.adjustment.AdjustmentService;
import com.coway.trust.biz.logistics.asset.impl.AssetMngServiceImpl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("adjustmentService")
public class AdjustmentServiceImpl extends EgovAbstractServiceImpl implements AdjustmentService {

	private static final Logger logger = LoggerFactory.getLogger(AssetMngServiceImpl.class);

	@Resource(name = "adjustmentMapper")
	private AdjustmentMapper adjustmentMapper;

	@Override
	public void insertNewAdjustment(Map<String, Object> params) {

		String adjNo = adjustmentMapper.selectNewAdjNo();

		params.put("adjNo", adjNo);
		List<Object> eventtype = (List<Object>) params.get("eventtype");
		List<Object> itemtype = (List<Object>) params.get("itemtype");

		String event = "";
		String item = "";
		for (int i = 0; i < eventtype.size(); i++) {
			event += eventtype.get(i);
			if (i == eventtype.size() - 1) {
				event += "";
			} else {
				event += ",";

			}
		}
		params.put("event", event);
		logger.debug("event : {} ", event);
		for (int j = 0; j < itemtype.size(); j++) {
			item += itemtype.get(j);
			if (j == itemtype.size() - 1) {
				item += "";
			} else {
				item += ",";

			}
		}
		logger.debug("item : {} ", item);
		params.put("item", item);

		adjustmentMapper.insertNewAdjustment(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentList(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentLocationList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentLocationList(params);
	}

	@Override
	public void insertAdjustmentList(Map<String, Object> params) {
		// TODO Auto-generated method stub

	}

	@Override
	public int selectAdjustmentNo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentNo(params);
	}

	@Override
	public List<EgovMap> selectCodeList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectCodeList(params);
	}

	@Override
	public void insertAdjustmentLocAuto(Map<String, Object> params) {
		adjustmentMapper.insertAdjustmentLoc(params);
		adjustmentMapper.insertAdjustmentLocItem(params);
	}

	@Override
	public void insertAdjustmentLocManual(Map<String, Object> params) {
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> addList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

		formMap.get("autoFlag");
		formMap.get("invntryNo");

		logger.debug("invntryNo : {} ", formMap.get("invntryNo"));

		String tmp = String.valueOf(formMap.get("eventType"));
		List<Object> eventList = Arrays.asList(tmp.split(","));
		String tmp2 = String.valueOf(formMap.get("itmType"));
		List<Object> itemList = Arrays.asList(tmp2.split(","));

		params.put("invntryNo", formMap.get("invntryNo"));
		params.put("itemList", itemList);
		if (addList.size() > 0) {
			for (int i = 0; i < addList.size(); i++) {
				Map<String, Object> getMap = (Map<String, Object>) addList.get(i);
				logger.debug("addList : {} ", addList.get(i).toString());
				logger.debug("adjwhLocId : {} ", getMap.get("adjwhLocId"));
				Map<String, Object> setMap = new HashMap();
				setMap.put("invntryNo", formMap.get("invntryNo"));
				// setMap.put("autoFlag", formMap.get("autoFlag"));
				setMap.put("adjwhLocId", getMap.get("adjwhLocId"));
				setMap.put("eventList", eventList);
				setMap.put("itemList", itemList);
				adjustmentMapper.insertAdjustmentLoc(setMap);
			}
			adjustmentMapper.insertAdjustmentLocItem(params);
		}
	}

	@Override
	public List<EgovMap> selectAdjustmentLocationReqList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentLocationReqList(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentDetailLoc(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentDetailLoc(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentCountingDetail(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentCountingDetail(params);
	}

	@Override
	public List<EgovMap> selectCheckSerial(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectCheckSerial(params);
	}

	@Override
	public void insertAdjustmentLocSerial(Map<String, Object> params) {
		Map<String, Object> formMap = (Map<String, Object>) params.get(AppConstants.AUIGRID_FORM);
		List<Object> addList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);

		logger.debug("formMap : {} ", formMap.toString());
		logger.debug("addList size : {} ", addList.size());
		if (addList.size() > 0) {
			for (int i = 0; i < addList.size(); i++) {
				Map<String, Object> getMap = (Map<String, Object>) addList.get(i);
				logger.debug("addList : {} ", addList.get(i).toString());
				Map<String, Object> setMap = new HashMap();
				setMap.put("serial", getMap.get("serial"));
				setMap.put("adjLocIdPop", formMap.get("adjLocIdPop"));
				setMap.put("adjItemPop", formMap.get("adjItemPop"));
				setMap.put("loginId", params.get("loginId"));
				// adjustmentMapper.insertAdjustmentLocSerial(setMap);
			}
		}

	}

	@Override
	public void insertAdjustmentLocCount(Map<String, Object> params) {
		List<Object> addList = (List<Object>) params.get(AppConstants.AUIGRID_UPDATE);
		logger.debug("adj addList : {} ", addList.toString());
		if (addList.size() > 0) {
			for (int i = 0; i < addList.size(); i++) {
				Map<String, Object> getMap = (Map<String, Object>) addList.get(i);
				logger.debug("addList : {} ", addList.get(i).toString());
				/*
				 * Map<String, Object> setMap = new HashMap(); setMap.put("serial", getMap.get("serial"));
				 * setMap.put("adjLocIdPop", formMap.get("adjLocIdPop")); setMap.put("adjItemPop",
				 * formMap.get("adjItemPop")); setMap.put("loginId", params.get("loginId"));
				 */
				// adjustmentMapper.insertAdjustmentLocSerial(setMap);
			}
		}
	}
}
