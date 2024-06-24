package com.coway.trust.biz.supplement.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.supplement.SupplementTagManagementService;
import com.coway.trust.biz.supplement.impl.SupplementTagManagementMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("supplementTagManagementService")
public class SupplementTagManagementImpl extends EgovAbstractServiceImpl implements SupplementTagManagementService{

	private static final Logger LOGGER = LoggerFactory.getLogger(SupplementTagManagementImpl.class);

	  @Resource(name = "supplementTagManagementMapper")
	  private SupplementTagManagementMapper supplementTagManagementMapper;




@Override
public List<EgovMap> selectTagStus() {
	return supplementTagManagementMapper.selectTagStus();
}

@Override
public List<EgovMap> selectTagManagementList(Map<String, Object> params) throws Exception {

  return supplementTagManagementMapper.selectTagManagementList(params);
}

@Override
public List<EgovMap> getMainTopicList() {
  return supplementTagManagementMapper.getMainTopicList();
}

@Override
public List<EgovMap> getInchgDeptList() {
  return supplementTagManagementMapper.getInchgDeptList();
}

@Override
public List<EgovMap> getSubTopicList(Map<String, Object> params) {

  return supplementTagManagementMapper.getSubTopicList(params);
}

@Override
public List<EgovMap> getSubDeptList(Map<String, Object> params) {

  return supplementTagManagementMapper.getSubDeptList(params);
}

@Override
public EgovMap selectOrderBasicInfo(Map<String, Object> params) throws Exception {

  return supplementTagManagementMapper.selectOrderBasicInfo(params);
}

@Override
public EgovMap searchOrderBasicInfo(Map<String, Object> params) {

  return supplementTagManagementMapper.searchOrderBasicInfo(params);
}

@Override
public EgovMap selectViewBasicInfo(Map<String, Object> params) {

  return supplementTagManagementMapper.selectViewBasicInfo(params);
}
}
