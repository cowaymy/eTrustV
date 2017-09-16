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

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("adjustmentService")
public class AdjustmentServiceImpl extends EgovAbstractServiceImpl implements AdjustmentService {

	private static final Logger logger = LoggerFactory.getLogger(AdjustmentServiceImpl.class);

	@Resource(name = "adjustmentMapper")
	private AdjustmentMapper adjustmentMapper;

	@Override
	public void insertNewAdjustment(Map<String, Object> params) {

		String adjNo = adjustmentMapper.selectNewAdjNo();

		params.put("adjNo", adjNo);
		List<Object> eventtype = (List<Object>) params.get("eventtype");
		List<Object> itemtype = (List<Object>) params.get("itemtype");
		List<Object> catagorytype = (List<Object>) params.get("catagorytype");

		String event = "";
		String item = "";
		String catagory = "";
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
		for (int j = 0; j < catagorytype.size(); j++) {
			catagory += catagorytype.get(j);
			if (j == catagorytype.size() - 1) {
				catagory += "";
			} else {
				catagory += ",";

			}
		}
		logger.debug("catagory : {} ", catagory);
		params.put("catagory", catagory);

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
		String tmp3 = String.valueOf(formMap.get("ctgryType"));
		List<Object> catagoryList = Arrays.asList(tmp3.split(","));

		params.put("invntryNo", formMap.get("invntryNo"));
		params.put("itemList", itemList);
		params.put("catagoryList", catagoryList);
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
				setMap.put("catagoryList", catagoryList);
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

	@Override
	public void insertExcel(Map<String, Object> params) {
		// TODO Auto-generated method stub
		List<Object> addList = (List<Object>) params.get(AppConstants.AUIGRID_ADD);
		logger.debug("addList size : {} ", addList.size());
		logger.debug("adj addList : {} ", addList.toString());
		if (addList.size() > 0) {
			for (int i = 0; i < addList.size(); i++) {
				Map<String, Object> getMap = (Map<String, Object>) addList.get(i);
				// logger.debug("addList : {} ", addList.get(i).toString());
				Map<String, Object> setMap = new HashMap();
				logger.debug("invntryLocId : {} ", getMap.get("invntryLocId"));
				logger.debug("serialChk : {} ", getMap.get("serialChk"));
				setMap.put("invntryLocId", getMap.get("invntryLocId"));
				setMap.put("stkAdNo", getMap.get("Stock Audit No"));
				setMap.put("locId", getMap.get("locId"));
				setMap.put("seq", getMap.get("seq"));
				setMap.put("itmId", getMap.get("itmId"));
				setMap.put("serialChk", getMap.get("serialChk"));
				setMap.put("cntQty", getMap.get("cntQty"));
				if ("".equals(getMap.get("serialChk")) || null == getMap.get("serialChk")) {
					adjustmentMapper.insertExcel(setMap);
				}
			}
		}
	}

	@Override
	public int updateSaveYn(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.updateSaveYn(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentApproval(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentApproval(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentApprovalCnt(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentApprovalCnt(params);
	}

	@Override
	public List<EgovMap> selectAdjustmentApprovalLineCheck(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return adjustmentMapper.selectAdjustmentApprovalLineCheck(params);
	}

	@Override
	public void updateApproval(Map<String, Object> params) {
		// TODO Auto-generated method stub
		adjustmentMapper.updateApproval(params);
	}

	@Override
	public void updateDoc(Map<String, Object> setmap) {
		// TODO Auto-generated method stub
		adjustmentMapper.updateDoc(setmap);
	}
}
