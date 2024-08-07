package com.coway.trust.biz.logistics.serialmgmt.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.serialmgmt.SerialLastInfoMgmtService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : SerialLastInfoMgmtServiceImpl.java
 * @Description : Serial No. Last Info Management Service
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 22.   KR-OHK        First creation
 * </pre>
 */
@Service("serialLastInfoMgmtService")
public class SerialLastInfoMgmtServiceImpl implements SerialLastInfoMgmtService {

	private static final Logger logger = LoggerFactory.getLogger(SerialLastInfoMgmtServiceImpl.class);

	@Resource(name = "serialLastInfoMgmtMapper")
	private SerialLastInfoMgmtMapper serialLastInfoMgmtMapper;

	@Override
	public int selectSerialLastInfoListCnt(Map<String, Object> params) {
		return serialLastInfoMgmtMapper.selectSerialLastInfoListCnt(params);
	}

	@Override
	public List<EgovMap> selectSerialLastInfoList(Map<String, Object> params) {
		return serialLastInfoMgmtMapper.selectSerialLastInfoList(params);
	}
	@Override
	public List<EgovMap> selectSerialLastInfoHistoryList(Map<String, Object> params) {
		return serialLastInfoMgmtMapper.selectSerialLastInfoHistoryList(params);
	}

	@Override
	public List<EgovMap> selectOrderBasicInfoByOrderId(Map<String, Object> params) {
		return serialLastInfoMgmtMapper.selectOrderBasicInfoByOrderId(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveSerialLastInfo(Map<String, Object> params) {

		Map<String, Object> gridData = (Map<String, Object>) params.get("gridData");

		List<Object> addList = (List<Object>) gridData.get(AppConstants.AUIGRID_ADD);
		List<Object> updList = (List<Object>) gridData.get(AppConstants.AUIGRID_UPDATE);

		for (Object obj : addList)
		{
			this.saveSerialLastInfoProc(params, obj, AppConstants.AUIGRID_ADD);
		}

		for (Object obj : updList)
		{
			this.saveSerialLastInfoProc(params, obj, AppConstants.AUIGRID_UPDATE);
		}
	}

	@SuppressWarnings("unchecked")
	private void saveSerialLastInfoProc(Map<String, Object> params, Object obj, String procType) {
		// Check Valid
		params.put("serialNo", ((Map<String, Object>) obj).get("serialNo"));
		params.put("stusCode", ((Map<String, Object>) obj).get("stusCode"));
		params.put("lastLocCode", ((Map<String, Object>) obj).get("lastLocCode"));
		params.put("lastLocType", ((Map<String, Object>) obj).get("lastLocType"));
		params.put("itmCode", ((Map<String, Object>) obj).get("itmCode"));
		params.put("lastReqstNo", ((Map<String, Object>) obj).get("lastReqstNo"));
		params.put("lastDelvryNo", ((Map<String, Object>) obj).get("lastDelvryNo"));
		params.put("tempScanNo", ((Map<String, Object>) obj).get("tempScanNo"));
		params.put("hidSerialNo", ((Map<String, Object>) obj).get("hidSerialNo"));

		EgovMap validMap = serialLastInfoMgmtMapper.checkSerialLastInfoValid(params);

		if(CommonUtils.isEmpty(params.get("serialNo"))) {
			throw new ApplicationException(AppConstants.FAIL, "Serial No is required.");
		}
		if(CommonUtils.isEmpty(params.get("stusCode"))) {
			throw new ApplicationException(AppConstants.FAIL, "In/Out is required.");
		}
		if(CommonUtils.isEmpty(params.get("lastLocCode"))) {
			throw new ApplicationException(AppConstants.FAIL, "Location Code is required.");
		}
		if(CommonUtils.isEmpty(params.get("lastLocType"))) {
			throw new ApplicationException(AppConstants.FAIL, "Location Type is required.");
		}
		if(CommonUtils.isEmpty(params.get("itmCode"))) {
			throw new ApplicationException(AppConstants.FAIL, "Item Code is required.");
		}
		if(procType.equals(AppConstants.AUIGRID_ADD)) {
    		if(CommonUtils.isNotEmpty(params.get("serialNo")) && Integer.parseInt(String.valueOf(validMap.get("dupCnt"))) > 0  )	{
    			throw new ApplicationException(AppConstants.FAIL, "Serial No is existing.");
    		}
		} else if(procType.equals(AppConstants.AUIGRID_UPDATE)) {
			if(!params.get("serialNo").equals(params.get("hidSerialNo")))	{
    			throw new ApplicationException(AppConstants.FAIL, "Invalid Serial No.<br />[ Serial No : " + params.get("serialNo") +  " ]");
    		}
		}
		/*if(CommonUtils.isNotEmpty(params.get("lastReqstNo")) && Integer.parseInt(String.valueOf(validMap.get("validReqstCnt"))) == 0  )	{
			throw new ApplicationException(AppConstants.FAIL, "Invalid Request No.<br />[ Request No : " + params.get("lastReqstNo") +  " ]");
		}
		if(CommonUtils.isNotEmpty(params.get("lastDelvryNo")) && Integer.parseInt(String.valueOf(validMap.get("validDelvryCnt"))) == 0  )	{
			throw new ApplicationException(AppConstants.FAIL, "Invalid Delivery No.<br />[ Delivery No : " + params.get("lastDelvryNo") +  " ]");
		}*/
		if(CommonUtils.isNotEmpty(params.get("tempScanNo")) && Integer.parseInt(String.valueOf(validMap.get("validScanCnt"))) == 0  )	{
			throw new ApplicationException(AppConstants.FAIL, "Invalid Temporay Scan No.<br />[ Temporay Scan No : " + params.get("tempScanNo") +  " ]");
		}

		((Map<String, Object>) obj).put("userId", params.get("userId"));

		serialLastInfoMgmtMapper.saveSerialLastInfo((Map<String, Object>) obj);
		serialLastInfoMgmtMapper.insertSerialLastInfoHistory(params);
	}
}
