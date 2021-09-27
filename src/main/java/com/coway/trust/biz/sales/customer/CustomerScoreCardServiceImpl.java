package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.customer.impl.CustomerScoreCardMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("customerScoreCardService")
public class CustomerScoreCardServiceImpl extends EgovAbstractServiceImpl implements CustomerScoreCardService {

  @Resource(name = "customerScoreCardMapper")
  private CustomerScoreCardMapper customerScoreCardMapper;

  /**
   * 글 목록을 조회한다.
   *
   * @param OrderCancelVO
   *          - 조회할 정보가 담긴 VO
   * @return 글 목록
   * @exception Exception
   */
  public List<EgovMap> customerScoreCardList(Map<String, Object> params) {
    return customerScoreCardMapper.customerScoreCardList(params);
  }
}
