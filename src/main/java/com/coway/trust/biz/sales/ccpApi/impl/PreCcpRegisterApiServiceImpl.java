package com.coway.trust.biz.sales.ccpApi.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.time.StopWatch;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.sales.ccpApi.PreCcpRegisterApiDto;
import com.coway.trust.api.mobile.sales.ccpApi.PreCcpRegisterApiForm;
import com.coway.trust.biz.api.CommonApiService;
import com.coway.trust.biz.api.impl.CommonApiMapper;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.biz.sales.ccpApi.PreCcpRegisterApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.cmmn.model.LoginVO;
import com.coway.trust.util.CommonUtils;
import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : PreCcpRegisterApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 *
 *          <pre>
 * Date             		Author          		Description
 * -------------    	-----------     		-------------
 * 2023. 02. 08.    Low Kim Ching   First creation
 *          </pre>
 */
@Service("PreCcpRegisterApiService")
public class PreCcpRegisterApiServiceImpl extends EgovAbstractServiceImpl implements PreCcpRegisterApiService {

  @Resource(name = "PreCcpRegisterApiMapper")
  private PreCcpRegisterApiMapper preCcpRegisterApiMapper;


  @Override
  public List<EgovMap> selectPreCcpRegisterList(PreCcpRegisterApiForm param) throws Exception {
        if (null == param) {
          throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }

        if (CommonUtils.isEmpty(param.getSelectType())) {
          throw new ApplicationException(AppConstants.FAIL, "Select Type value does not exist.");
        }

        else {
              if (("1").equals(param.getSelectType()) && param.getSelectKeyword().length() < 3) {
                throw new ApplicationException(AppConstants.FAIL, "Please fill out at least three characters.");
              }
              if ( ("2").equals(param.getSelectType()) && CommonUtils.isEmpty(param.getSelectKeyword())) {
                throw new ApplicationException(AppConstants.FAIL, "Select Keyword value does not exist.");
              }
        }

        if (CommonUtils.isEmpty(param.getMemId()) || param.getMemId() <= 0) {
          throw new ApplicationException(AppConstants.FAIL, "mdmId value does not exist.");
        }

        return preCcpRegisterApiMapper.selectPreCcpRegisterList(PreCcpRegisterApiForm.createMap(param));
  }

}
