/**
 * 
 */
/**
 * @author methree
 *
 */
package com.coway.trust.biz.logistics.replenishment.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.replenishment.ReplenishmentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("ReplenishmentService")
public class ReplenishmentServiceImpl extends EgovAbstractServiceImpl implements ReplenishmentService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "ReplenishmentMapper")
	private ReplenishmentMapper replenishment;

	@Override
	public Map<String, Object> excelDataSearch(Map<String, Object> params) {

		Map<String, Object> hdMap = replenishment.excelDataSearch(params);

		return hdMap;
	}

	@Override
	public void relenishmentSave(Map<String, Object> params, int userid) {
		// TODO Auto-generated method stub
		List<Object> insList = (List<Object>) params.get("add");
		List<Object> updList = (List<Object>) params.get("update");
		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				insMap.put("userid", userid);
				replenishment.relenishmentSave(insMap);
			}
		}

		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> updMap = (Map<String, Object>) updList.get(i);
				updMap.put("userid", userid);
				replenishment.relenishmentSave(updMap);
			}
		}

	}

	@Override
	public List<EgovMap> searchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return replenishment.selectSearchList(params);
	}

	@Override
	public void relenishmentPopSave(Map<String, Object> params, int userid) {
		// TODO Auto-generated method stub
		params.put("userid", userid);
		replenishment.relenishmentSave(params);

	}

	@Override
	public List<EgovMap> searchListRdc(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return replenishment.searchListRdc(params);
	}

	@Override
	public List<EgovMap> searchAutoCTList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return replenishment.searchAutoCTList(params);
	}

	@Override
	public List<EgovMap> PopCheck(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return replenishment.PopCheck(params);
	}

	@Override
	public void relenishmentSaveCt(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		logger.debug("insList.size() {}", insList.size());
		if (insList.size() > 0) {
			List<Map> tmplist = new ArrayList<>();
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> tmpmap = new HashMap();
				// int cnt = 0;

				Map<String, Object> getmap = (Map<String, Object>) insList.get(i);
				String rdc = String.valueOf(getmap.get("rdc"));
				String loccd = String.valueOf(getmap.get("loccd"));
				String reqdt = String.valueOf(getmap.get("reqdt"));
				String all = rdc + loccd + reqdt;
				tmpmap.put("rdc", rdc);
				tmpmap.put("loccd", loccd);
				tmpmap.put("reqdt", reqdt);
				tmpmap.put("userId", params.get("userId"));
				tmpmap.put("all", all);
				tmplist.add(tmpmap);
			}
			HashSet<Map> hs = new HashSet<Map>(tmplist);
			List<Map> tmplist2 = new ArrayList<Map>(hs);
			logger.debug("tmplist2 {}", tmplist2);

			List<Map> tmplist3 = new ArrayList();
			for (int i = 0; i < tmplist2.size(); i++) {
				String seq = replenishment.selectStockMovementSeq();
				Map<String, Object> tmpmap = new HashMap();

				Map<String, Object> getmap = tmplist2.get(i);
				String rdc = String.valueOf(getmap.get("rdc"));
				String loccd = String.valueOf(getmap.get("loccd"));
				String reqdt = String.valueOf(getmap.get("reqdt"));
				String userId = String.valueOf(getmap.get("userId"));
				String all = String.valueOf(getmap.get("all"));

				tmpmap.put("rdc", rdc);
				tmpmap.put("loccd", loccd);
				tmpmap.put("reqdt", reqdt);
				tmpmap.put("userId", userId);
				tmpmap.put("all", all);
				tmpmap.put("reqno", seq);
				tmplist3.add(tmpmap);

				replenishment.insStockMovementHead(tmpmap);

			}
			logger.debug("tmplist3 {}", tmplist3);

			for (Map<String, Object> map : tmplist3) {
				String keyChck = String.valueOf(map.get("all"));
				for (int i = 0; i < insList.size(); i++) {
					Map<String, Object> setmap = (Map<String, Object>) insList.get(i);
					String rdc2 = String.valueOf(setmap.get("rdc"));
					String loccd2 = String.valueOf(setmap.get("loccd"));
					String reqdt2 = String.valueOf(setmap.get("reqdt"));
					String all2 = rdc2 + loccd2 + reqdt2;
					int availqty = (Integer) setmap.get("availqty");
					int remainqty = (Integer) setmap.get("remainqty");
					int reordqty = (Integer) setmap.get("reordqty");
					// availqty
					// remainqty
					// reqqty
					int tt = availqty + remainqty;
					logger.debug("all : all2 {} : {}", keyChck, all2);
					logger.debug("tt : reqqty {} : {}", tt, reordqty);
					if (keyChck.equals(all2) && reordqty > tt) {
						logger.debug("all2 {}", all2);

						// detail
						setmap.put("reqno", map.get("reqno"));
						setmap.put("userId", params.get("userId"));
						replenishment.insStockMovementDetail(setmap);
					}
				}
			}
		}

	}

	@Override
	public void relenishmentSaveRdc(Map<String, Object> params) {
		List<Object> insList = (List<Object>) params.get("add");
		logger.debug("insList.size() {}", insList.size());
		if (insList.size() > 0) {
			List<Map> tmplist = new ArrayList<>();
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> tmpmap = new HashMap();
				// int cnt = 0;

				Map<String, Object> getmap = (Map<String, Object>) insList.get(i);
				String rdc = String.valueOf(getmap.get("cdc"));
				String loccd = String.valueOf(getmap.get("loccd"));
				String reqdt = String.valueOf(getmap.get("reqdt"));
				String all = rdc + loccd + reqdt;
				tmpmap.put("rdc", rdc);
				tmpmap.put("loccd", loccd);
				tmpmap.put("reqdt", reqdt);
				tmpmap.put("userId", params.get("userId"));
				tmpmap.put("all", all);
				tmplist.add(tmpmap);
			}
			HashSet<Map> hs = new HashSet<Map>(tmplist);
			List<Map> tmplist2 = new ArrayList<Map>(hs);
			logger.debug("tmplist2 {}", tmplist2);

			List<Map> tmplist3 = new ArrayList();
			for (int i = 0; i < tmplist2.size(); i++) {
				String seq = replenishment.selectStockMovementSeq();
				Map<String, Object> tmpmap = new HashMap();

				Map<String, Object> getmap = tmplist2.get(i);
				String rdc = String.valueOf(getmap.get("rdc"));
				String loccd = String.valueOf(getmap.get("loccd"));
				String reqdt = String.valueOf(getmap.get("reqdt"));
				String userId = String.valueOf(getmap.get("userId"));
				String all = String.valueOf(getmap.get("all"));

				tmpmap.put("rdc", rdc);
				tmpmap.put("loccd", loccd);
				tmpmap.put("reqdt", reqdt);
				tmpmap.put("userId", userId);
				tmpmap.put("all", all);
				tmpmap.put("reqno", seq);
				tmplist3.add(tmpmap);

				replenishment.insStockMovementHead(tmpmap);

			}
			logger.debug("tmplist3 {}", tmplist3);

			for (Map<String, Object> map : tmplist3) {
				String keyChck = String.valueOf(map.get("all"));
				for (int i = 0; i < insList.size(); i++) {
					Map<String, Object> setmap = (Map<String, Object>) insList.get(i);
					String rdc2 = String.valueOf(setmap.get("cdc"));
					String loccd2 = String.valueOf(setmap.get("loccd"));
					String reqdt2 = String.valueOf(setmap.get("reqdt"));
					String all2 = rdc2 + loccd2 + reqdt2;
					int availqty = (Integer) setmap.get("availqty");
					int remainqty = (Integer) setmap.get("remainqty");
					int reordqty = (Integer) setmap.get("reordqty");
					// availqty
					// remainqty
					// reqqty
					int tt = availqty + remainqty;
					logger.debug("all : all2 {} : {}", keyChck, all2);
					logger.debug("tt : reqqty {} : {}", tt, reordqty);
					if (keyChck.equals(all2) && reordqty > tt) {
						logger.debug("all2 {}", all2);

						// detail
						setmap.put("reqno", map.get("reqno"));
						setmap.put("userId", params.get("userId"));
						replenishment.insStockMovementDetail(setmap);
					}
				}
			}
		}

	}

	@Override
	public List<EgovMap> searchListMaster(Map<String, Object> params) {
		return replenishment.searchListMaster(params);
	}

	@Override
	public void relenishmentSaveMsCt(Map<String, Object> params, int userId) {
		List<Object> insList = (List<Object>) params.get("add");
		List<Object> updList = (List<Object>) params.get("update");
		if (insList.size() > 0) {
			for (int i = 0; i < insList.size(); i++) {
				Map<String, Object> insMap = (Map<String, Object>) insList.get(i);
				insMap.put("userid", userId);
				replenishment.relenishmentSaveMsCt(insMap);
			}
		}

		if (updList.size() > 0) {
			for (int i = 0; i < updList.size(); i++) {
				Map<String, Object> updMap = (Map<String, Object>) updList.get(i);
				updMap.put("userid", userId);
				replenishment.relenishmentSaveMsCt(updMap);
			}
		}
	}

	@Override
	public List<EgovMap> searchListMasterDsc(Map<String, Object> params) {
		return replenishment.searchListMasterDsc(params);
	}
}
