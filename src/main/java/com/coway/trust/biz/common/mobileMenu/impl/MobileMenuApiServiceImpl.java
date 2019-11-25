package com.coway.trust.biz.common.mobileMenu.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.coway.trust.biz.common.mobileMenu.MobileMenuApiService;
import com.coway.trust.biz.login.impl.LoginMapper;
import com.coway.trust.cmmn.model.LoginVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;


/**
 * @ClassName : MobileMenuApiServiceImpl.java
 * @Description : MobileMenuApiServiceImpl
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 1.   KR-HAN        First creation
 * </pre>
 */
@Service("mobileMenuApiService")
public class MobileMenuApiServiceImpl extends EgovAbstractServiceImpl implements MobileMenuApiService {

	@Resource(name = "mobileMenuApiMapper")
	private MobileMenuApiMapper mobileMenuApiMapper;

	@Autowired
	private LoginMapper loginMapper;

	private static final Logger logger = LoggerFactory.getLogger(MobileMenuApiServiceImpl.class);

	/**
	 * selectMobileMenuList
	 * @Author KR-HAN
	 * @Date 2019. 11. 1.
	 * @param params
	 * @return
	 * @see com.coway.trust.biz.common.mobileMenu.MobileMenuApiService#selectMobileMenuList(java.util.Map)
	 */
	@Override
	public List<EgovMap> selectMobileMenuList(Map<String, Object> params) {

    	params.put("_USER_ID", params.get("userId") );
		LoginVO loginVO = loginMapper.selectLoginInfoById(params);
		params.put("userId",  loginVO.getUserId());

		return mobileMenuApiMapper.selectMobileMenuList(params);
	}

}
