package com.coway.trust.biz.sales.ccp.impl;

import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import javax.annotation.Resource;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.coway.trust.AppConstants;
import com.coway.trust.biz.common.FileGroupVO;
import com.coway.trust.biz.common.FileService;
import com.coway.trust.biz.common.FileVO;
import com.coway.trust.biz.common.impl.FileMapper;
import com.coway.trust.biz.common.type.FileType;
import com.coway.trust.biz.sales.ccp.PreCcpRegisterService;
import com.coway.trust.cmmn.model.SmsVO;
import com.coway.trust.web.sales.SalesConstants;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("preCcpRegisterService")
public class PreCcpRegisterServiceImpl extends EgovAbstractServiceImpl implements PreCcpRegisterService {

	private static final Logger LOGGER = LoggerFactory.getLogger(PreCcpRegisterServiceImpl.class);

	@Resource(name = "preCcpRegisterMapper")
	private PreCcpRegisterMapper preCcpRegisterMapper;

	@Override
	@Transactional
	public int submitPreCcpSubmission(Map<String, Object> params) throws Exception {
	    int result= preCcpRegisterMapper.submitPreCcpSubmission(params);
	    return result;
	}

	@Override
	public EgovMap getExistCustomer(Map<String, Object> params) {
		return preCcpRegisterMapper.getExistCustomer(params);
	}

	@Override
	public List<EgovMap> selectPreCcpStatus() {
	    return preCcpRegisterMapper.selectPreCcpStatus();
	}

    @Override
	public List<EgovMap> searchPreCcpRegisterList(Map<String, Object> params) {
	    return preCcpRegisterMapper.searchPreCcpRegisterList(params);
	}

}