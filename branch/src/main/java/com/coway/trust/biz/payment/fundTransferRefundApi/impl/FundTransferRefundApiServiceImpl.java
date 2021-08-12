package com.coway.trust.biz.payment.fundTransferRefundApi.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.coway.trust.AppConstants;
import com.coway.trust.api.mobile.payment.fundTransferRefundApi.FundTransferRefundApiForm;
import com.coway.trust.biz.payment.fundTransferRefundApi.FundTransferRefundApiService;
import com.coway.trust.cmmn.exception.ApplicationException;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

/**
 * @ClassName : FundTransferRefundApiServiceImpl.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date             Author          Description
 * -------------    -----------     -------------
 * 2019. 10. 10.    KR-JAEMJAEM:)   First creation
 * </pre>
 */
@Service("FundTransferRefundApiService")
public class FundTransferRefundApiServiceImpl extends EgovAbstractServiceImpl implements FundTransferRefundApiService{



	@Resource(name = "FundTransferRefundApiMapper")
	private FundTransferRefundApiMapper fundTransferRefundApiMapper;



	@Override
    public List<EgovMap> selectFundTransferRefundList(FundTransferRefundApiForm param) throws Exception {
	    if( null == param ){
            throw new ApplicationException(AppConstants.FAIL, "Parameter value does not exist.");
        }
	    if( CommonUtils.isEmpty(param.getType()) ){
	        throw new ApplicationException(AppConstants.FAIL, "Type value does not exist.");
	    }
        if( CommonUtils.isEmpty(param.getTransactionDateFrom()) || CommonUtils.isEmpty(param.getTransactionDateTo()) ){
            throw new ApplicationException(AppConstants.FAIL, "Transaction Date value does not exist.");
        }
	    if( CommonUtils.isEmpty(param.getSelectType()) ){
            throw new ApplicationException(AppConstants.FAIL, "Select Type value does not exist.");
        }
        if( CommonUtils.isEmpty(param.getSelectKeyword()) ){
            throw new ApplicationException(AppConstants.FAIL, "Select Keyword value does not exist.");
        }
        if( param.getSelectType().equals("2") && param.getSelectKeyword().length() < 5 ){
            throw new ApplicationException(AppConstants.FAIL, "Please enter at least 5 characters.");
        }
        if( param.getType().equals("1") == false && param.getType().equals("2") == false ){
            throw new ApplicationException(AppConstants.FAIL, "Type value does not exist.");
        }
	    return fundTransferRefundApiMapper.selectFundTransferRefundList(FundTransferRefundApiForm.createMap(param));
	}
}
