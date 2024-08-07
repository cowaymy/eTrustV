package com.coway.trust.biz.logistics.memorandumApi.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.logistics.memorandumApi.MemorandumApiFormDto;
import com.coway.trust.biz.logistics.memorandumApi.MemorandumApiService;
import com.coway.trust.cmmn.exception.PreconditionException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : MemorandumApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 09. 05.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("MemorandumApiService")
public class MemorandumApiServiceImpl extends EgovAbstractServiceImpl implements MemorandumApiService{



	@Resource(name = "MemorandumApiMapper")
	private MemorandumApiMapper memorandumApiMapper;



    @Override
    public List<EgovMap> selectMemorandumList(MemorandumApiFormDto param) {
        if( CommonUtils.isEmpty(param.getCrtDtFrom()) || CommonUtils.isEmpty(param.getCrtDtTo()) ){
            throw new PreconditionException(AppConstants.FAIL, "Create Date value does not exist.");
        }
        if( CommonUtils.isNotEmpty(param.getSelectType()) && CommonUtils.isEmpty(param.getSelectKeyword()) ){
            throw new PreconditionException(AppConstants.FAIL, "Keyword value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getUserTypeId()) ){
            throw new PreconditionException(AppConstants.FAIL, "User type ID value does not exist.");
        }
//TODO  강재민 보류 확인후 주석해제
//        if( CommonUtils.isEmpty(param.getCrtDeptId()) ){보류
//            throw new PreconditionException(AppConstants.FAIL, "Create Dept ID value does not exist.");
//        }
        return memorandumApiMapper.selectMemorandumList(MemorandumApiFormDto.createMap(param));
    }
}