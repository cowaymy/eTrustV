package com.coway.trust.biz.organization.organization.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.coway.trust.biz.organization.organization.MemberHospitalizeService;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("memberHospitalizeService")
public class MemberHospitalizeServiceImpl extends EgovAbstractServiceImpl implements MemberHospitalizeService {

	@SuppressWarnings("unused")
	private static final Logger logger = LoggerFactory.getLogger(MemberHospitalizeServiceImpl.class);

	@Value("${app.name}")
	private String appName;

	@Resource(name = "memberHospitalizeMapper")
	private MemberHospitalizeMapper memberHospitalizeMapper;

	@Autowired
	private MessageSourceAccessor messageSourceAccessor;

  @Override
  public List<EgovMap> selectHospitalizeUploadList(Map<String, Object> params) {
    return memberHospitalizeMapper.selectHospitalizeUploadList(params);
  }

  @Override
  public List<EgovMap> selectHospitalizeDetails(Map<String, Object> params) {
    return memberHospitalizeMapper.selectHospitalizeDetails(params);
  }

  @Override
  public int cntUploadBatch(Map<String, Object> params) {
    return memberHospitalizeMapper.cntUploadBatch(params);
  }

  @Override
  public int insertHospitalizeMaster(Map<String, Object> params) {
    return memberHospitalizeMapper.insertHospitalizeMaster(params);
  }

  @Override
  public void insertHospitalizeDetails(Map<String, Object> params) {
    memberHospitalizeMapper.insertHospitalizeDetails(params);
  }

  @Override
  public void callCnfmHsptalize(Map<String, Object> params) {
    memberHospitalizeMapper.callCnfmHsptalize(params);
  }

  @Override
  public void deactivateHspitalize(Map<String, Object> params) {
    memberHospitalizeMapper.deactivateHspitalize(params);
  }

}
