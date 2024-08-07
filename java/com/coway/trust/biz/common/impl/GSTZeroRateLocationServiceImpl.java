package com.coway.trust.biz.common.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.GSTZeroRateLocationService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("gstZeroRateLocationService")
public class GSTZeroRateLocationServiceImpl implements GSTZeroRateLocationService {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonServiceImpl.class);

	@Autowired
	private GSTZeroRateLocationMapper gstZeroRateLocationMapper;

	// GST Zero Rate Exportation
	@Override
	public List<EgovMap> selectGSTExportationList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectGSTExportationList(params);
	}

	@Override
	public List<EgovMap> selectGSTExportDealerList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectGSTExportDealerList(params);
	}

	/*
	@Override
	public int deleteGSTExportation(List<Object> addList, Integer crtUserId)
	{
		int saveCnt = 0;

		for (Object obj : addList)
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			LOGGER.debug(" >>>>> deleteGSTExportation ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));

			//String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			//((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );

			saveCnt++;

			gstZeroRateLocationMapper.deleteGSTExportation((Map<String, Object>) obj);
		}

		return saveCnt;
	}

	@Override
	public int updateGSTExportation(List<Object> addList, Integer crtUserId)
	{
		int saveCnt = 0;

		for (Object obj : addList)
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			LOGGER.debug(" >>>>> updateGSTExportation ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));

			//String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			//((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );

			saveCnt++;

			gstZeroRateLocationMapper.updateGSTExportation((Map<String, Object>) obj);
		}

		return saveCnt;
	}

	@Override
	public int insertGSTExportation(List<Object> addList, Integer crtUserId)
	{
		int saveCnt = 0;

		for (Object obj : addList)
		{
			((Map<String, Object>) obj).put("crtUserId", crtUserId);
			((Map<String, Object>) obj).put("updUserId", crtUserId);

			LOGGER.debug(" >>>>> insertGSTExportation ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));

			//String tmpStr =  (String) ((Map<String, Object>) obj).get("hidden");
			//((Map<String, Object>) obj).put("userId", ((Map<String, Object>) obj).get("userId") );

			saveCnt++;

			gstZeroRateLocationMapper.insertGSTExportation((Map<String, Object>) obj);
		}

		return saveCnt;
	}
	*/

	/**
	 * Insert, Update, Delete GSTExportation List : insertGSTExportation+updateGSTExportation+deleteGSTExportation => Change One Transaction
	 * @Author KR-OHK
	 * @Date 2019. 9. 10.
	 * @param addList
	 * @param udtList
	 * @param delList
	 * @param userId
	 * @return
	 * @see com.coway.trust.biz.common.GSTZeroRateLocationService#saveGSTExportation(java.util.List, java.util.List, java.util.List, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public int saveGSTExportation(List<Object> addList, List<Object> udtList, List<Object> delList, Integer userId)
	{
		int saveCnt = 0;

		// insert
		for (Object obj : addList)
		{
			((Map<String, Object>) obj).put("crtUserId", userId);
			((Map<String, Object>) obj).put("updUserId", userId);

			LOGGER.debug(" >>>>> saveGSTExportation insertGSTExportation ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));

			saveCnt++;

			gstZeroRateLocationMapper.insertGSTExportation((Map<String, Object>) obj);
		}

		// update
		for (Object obj : udtList)
		{
			((Map<String, Object>) obj).put("crtUserId", userId);
			((Map<String, Object>) obj).put("updUserId", userId);

			LOGGER.debug(" >>>>> saveGSTExportation updateGSTExportation ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));

			saveCnt++;

			gstZeroRateLocationMapper.updateGSTExportation((Map<String, Object>) obj);
		}

		// delete
		for (Object obj : delList)
		{
			((Map<String, Object>) obj).put("crtUserId", userId);
			((Map<String, Object>) obj).put("updUserId", userId);

			LOGGER.debug(" >>>>> saveGSTExportation deleteGSTExportation ");
			LOGGER.debug(" userId : {}", ((Map<String, Object>) obj).get("crtUserId"));

			saveCnt++;

			gstZeroRateLocationMapper.deleteGSTExportation((Map<String, Object>) obj);
		}

		return saveCnt;
	}

   //GST Zero Rate Location
	@Override
	public List<EgovMap> getStateCodeList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectStateCodeList(params);
	}

	@Override
	public List<EgovMap> getSubAreaList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectSubAreaList(params);
	}

	@Override
	public List<EgovMap> getPostCodeList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectPostCodeList(params);
	}

	@Override
	public List<EgovMap> getZRLocationList(Map<String, Object> params) {
		return gstZeroRateLocationMapper.selectZRLocationList(params);
	}

	@Override
	public void saveZRLocation(Map<String, ArrayList<Object>> params, int userId) {
		List<Object> updateList = params.get(AppConstants.AUIGRID_UPDATE);
		List<Object> addList = params.get(AppConstants.AUIGRID_ADD);

		Map<String, Object> param;
		for (Object map : updateList) {
			param = (HashMap<String, Object>) map;
			setUserId(param, userId);
			gstZeroRateLocationMapper.updateZrLocStusId(param);
		}

		for (Object map : addList) {
			param = (HashMap<String, Object>) map;
			setUserId(param, userId);
			gstZeroRateLocationMapper.insertZrLocStusId(param);
		}

	}

	private void setUserId(Map<String, Object> map, int userId) {
		map.put("userId", userId);
	}
}
