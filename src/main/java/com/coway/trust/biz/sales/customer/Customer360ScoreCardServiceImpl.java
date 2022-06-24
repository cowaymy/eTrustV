package com.coway.trust.biz.sales.customer;

import java.util.List;
import java.util.Map;
import javax.annotation.Resource;
import org.springframework.stereotype.Service;
import com.coway.trust.biz.sales.customer.impl.Customer360ScoreCardMapper;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.psl.dataaccess.util.EgovMap;

@Service("customer360ScoreCardService")
public class Customer360ScoreCardServiceImpl extends EgovAbstractServiceImpl implements Customer360ScoreCardService {

    @Resource(name = "customer360ScoreCardMapper")
    private Customer360ScoreCardMapper customer360ScoreCardMapper;

    public List<EgovMap> customer360ScoreCardList(Map<String, Object> params) {
        return customer360ScoreCardMapper.customer360ScoreCardList(params);
    }
}
