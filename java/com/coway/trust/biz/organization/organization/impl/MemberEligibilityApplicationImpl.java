package com.coway.trust.biz.organization.organization.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.application.impl.FileApplicationImpl;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.organization.organization.MemberEligibilityApplication;
import com.coway.trust.util.CommonUtils;

@Service("memberEligibilityApplication")
public class MemberEligibilityApplicationImpl implements MemberEligibilityApplication {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileApplicationImpl.class);

	@Value("${app.name}")
	private String appName;

	@Autowired
	private FileService fileService;

	@Autowired
	private FileMapper fileMapper;

	@Override
	public void insertMemberEligibilityAttachBiz(List<FileVO> list, FileType type, Map<String, Object> params) {
		// TODO Auto-generated method stub
		int fileGroupKey = fileService.insertFiles(list, type, (Integer) params.get("userId"));
		params.put("fileGroupKey", fileGroupKey);
	}
}
