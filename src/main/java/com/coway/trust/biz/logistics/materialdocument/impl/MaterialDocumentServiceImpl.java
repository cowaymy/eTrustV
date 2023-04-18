package com.coway.trust.biz.logistics.materialdocument.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.logistics.materialdocument.MaterialDocumentService;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("MaterialDocumentService")
public class MaterialDocumentServiceImpl extends EgovAbstractServiceImpl implements MaterialDocumentService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource(name = "MaterialDocumentMapper")
	private MaterialDocumentMapper MaterialDocumentMapper;

	@Override
	public List<EgovMap> selectLocation(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MaterialDocumentMapper.selectLocation(params);
	}

	@Override
	public List<EgovMap> MaterialDocSearchList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MaterialDocumentMapper.MaterialDocSearchList(params);
	}

	@Override
	public List<EgovMap> MaterialDocMovementType(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MaterialDocumentMapper.MaterialDocMovementType(params);
	}

	// 20191122 KR-OHK Serial List Add
	@Override
	public List<EgovMap> selectMaterialDocSerialList(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MaterialDocumentMapper.selectMaterialDocSerialList(params);
	}

	@Override
	public List<EgovMap> MaterialDocSearchListUpTo(Map<String, Object> params) {
		// TODO Auto-generated method stub
		return MaterialDocumentMapper.MaterialDocSearchListUpTo(params);
	}
}
