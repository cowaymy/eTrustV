package com.coway.trust.biz.logistics.serial.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.logistics.serial.SerialService;

import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("serialService")
public class SerialServiceImpl implements SerialService {

	private static final Logger logger = LoggerFactory.getLogger(SerialServiceImpl.class);

	@Resource(name = "serialMapper")
	private SerialMapper serialMapper;

	@Override
	public List<EgovMap> searchSeialList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return serialMapper.searchSeialList(params);
	}

	@Override
	public List<EgovMap> searchSeialListPop(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return serialMapper.searchSeialListPop(params);
	}

	@Override
	public List<EgovMap> selectSerialDetails(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return serialMapper.selectSerialDetails(params);
	}

	@Override
	public int updateSerial(List<Object> updateList, String loginId) {
		// TODO Auto-generated method stub
		int cnt = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginId", loginId);
		for (Object obj : updateList) {
			param.put("serialNo", ((Map<String, Object>) obj).get("serialNoPop"));
			param.put("matnr", ((Map<String, Object>) obj).get("matnrPop"));
			param.put("latransit", ((Map<String, Object>) obj).get("latransitPop"));
			param.put("gltri", ((Map<String, Object>) obj).get("gltriPop"));
			param.put("lvorm", ((Map<String, Object>) obj).get("lvormPop"));
			param.put("crtDt", ((Map<String, Object>) obj).get("crtDtPop"));
			// param.put("crtUserId", ((Map<String, Object>) obj).get("crtUserIdPop"));
			cnt = serialMapper.updateSerial(param);
		}
		return cnt;
	}

	@Override
	public int insertSerial(List<Object> addList, String loginId) {
		// TODO Auto-generated method stub
		int cnt = 0;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginId", loginId);
		for (Object obj : addList) {
			param.put("serialNo", ((Map<String, Object>) obj).get("serialNoPop"));
			param.put("matnr", ((Map<String, Object>) obj).get("matnrPop"));
			param.put("latransit", ((Map<String, Object>) obj).get("latransitPop"));
			param.put("gltri", ((Map<String, Object>) obj).get("gltriPop"));
			param.put("lvorm", ((Map<String, Object>) obj).get("lvormPop"));
			param.put("crtDt", ((Map<String, Object>) obj).get("crtDtPop"));
			// param.put("crtUserId", ((Map<String, Object>) obj).get("crtUserIdPop"));
			cnt = serialMapper.updateSerial(param);
		}
		return cnt;
	}

	@Override
	public List<EgovMap> selectSerialExist(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return serialMapper.selectSerialExist(params);
	}

	@Override
	public void insertExcelSerial(List<Object> addList, String loginId) {
		// TODO Auto-generated method stub
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("loginId", loginId);
		for (Object obj : addList) {
			param.put("serialNo", ((Map<String, Object>) obj).get("serialNo"));
			param.put("matnr", ((Map<String, Object>) obj).get("matnr"));
			param.put("gltri", ((Map<String, Object>) obj).get("gltri"));
			param.put("loginId", loginId);
			serialMapper.insertExcelSerial(param);
		}
	}

}
