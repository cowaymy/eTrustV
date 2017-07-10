/**
 * 
 */
package com.coway.trust.biz.sales.pst.impl;

import java.util.List;
import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Service;

import org.springframework.stereotype.Service;

import com.coway.trust.biz.sales.pst.PSTRequestDOService;
import com.coway.trust.biz.sales.pst.PSTRequestDOVO;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @author Yunseok_Jang
 *
 */
@Service("pstRequestDOService")
public class PSTRequestDOServiceImpl extends EgovAbstractServiceImpl implements PSTRequestDOService {

	private static final Logger logger = LoggerFactory.getLogger(PSTRequestDOServiceImpl.class);
	
	@Resource(name = "pstRequestDOMapper")
	private PSTRequestDOMapper pstRequestDOMapper;
	
	@Autowired
	private MessageSourceAccessor messageSourceAccessor;
	
	/**
	 * 글 목록을 조회한다.
	 * 
	 * @param pstRequestVO
	 *            - 조회할 정보가 담긴 VO
	 * @return 글 목록
	 * @exception Exception
	 */
	@Override
	public List<EgovMap> selectPstRequestDOList(PSTRequestDOVO pstRequestVO) {
		
		logger.debug("fail.common.dbmsg : {}", messageSourceAccessor.getMessage("fail.common.dbmsg"));
		return pstRequestDOMapper.selectPstRequestDOList(pstRequestVO);
	}
	
	
}
