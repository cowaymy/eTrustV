<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
    
<script type="text/javaScript">

</script>

<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/image/path_home.gif" alt="Home" /></li>
        <li>Payment</li>
        <li>Reconciliation</li>
        <li>Reconciliation Search</li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Credit Card Statement</h2>       
    </aside>
    <!-- title_line end -->
    
    <!-- search_table start -->
    <section class="search_table">
        <form name="searchForm" id="searchForm">
            <!-- table start -->
            <table class="type1">
                <caption>search table</caption>
                <colgroup>
                    <col style="width:144px" />
                    <col style="width:*" />
                    <col style="width:144px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Transaction No.</th>
                        <td><input type="text" title="Reference No." id="tranNo" name="tranNo" /></td>
                        <th scope="row">Bank Account</th>
                        <td>
                            <select id="bankAccount" name="bankAccount">
                                <option value="" selected>Select Account</option>
                                <c:forEach var="bankList" items="${ bankComboList}" varStatus="status">
                                    <option value="${bankList.accId}">${bankList.accDesc2}</option>
                                </c:forEach>                                
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Branch Code</th>
                        <td>
                            <select id="branchList" name="branchList">
                                    <option value="" selected>Branch</option>
                                    <c:forEach var="brnList" items="${ branchList}" varStatus="status">
                                        <option value="${brnList.brnchId}">${brnList.codeAndName}</option>
                                    </c:forEach>
                                </select>
                        </td>
                        <th scope="row">Payment Date</th>
                        <td>
                            <div class="date_set"><!-- date_set start -->
                                <p><input type="text"  name="paymentDate1" id="paymentDate1" title="Payment Date From" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            <span>To</span>
                            <p><input type="text"  name="paymentDate2" id="paymentDate2" title="Payment Date To" placeholder="DD/MM/YYYY" class="j_date" /></p>
                            </div><!-- date_set end -->
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Status</th>
                        <td>
                            <select  id="status" name="status" class="multy_select" multiple="multiple">
						        <option value="44">Pending</option>
						        <option value="6">Rejected</option>
						        <option value="10">Cancelled</option>
						        <option value="5">Approved</option>
						    </select>
                        </td>
                        <th scope="row"></th>
                        <td>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->

            <ul class="right_btns">
                <li><p class="btn_gray"><a href=""><span class="search"></span>Search</a></p></li>
            </ul>
        </form>
    </section>
    <!-- search_table end -->

    <!-- search_result start -->
    <section class="search_result">
        
        <!-- link_btns_wrap start -->
        <aside class="link_btns_wrap">
            <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/image/btn_link.gif" alt="link show" /></a></p>
            <dl class="link_list">
                <dt>Link</dt>
                <dd>
                    <ul class="btns">
                        <li><p class="link_btn"><a href="#">menu1</a></p></li>
                        <li><p class="link_btn"><a href="#">menu2</a></p></li>
                        <li><p class="link_btn"><a href="#">menu3</a></p></li>
                        <li><p class="link_btn"><a href="#">menu4</a></p></li>
                        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
                        <li><p class="link_btn"><a href="#">menu6</a></p></li>
                        <li><p class="link_btn"><a href="#">menu7</a></p></li>
                        <li><p class="link_btn"><a href="#">menu8</a></p></li>
                    </ul>
                    <ul class="btns">
                        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
                        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
                        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
                        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
                    </ul>
                    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/image/btn_link_close.gif" alt="hide" /></a></p>
                </dd>
            </dl>
        </aside>
        <!-- link_btns_wrap end -->
        
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
        
        <!-- bottom_msg_box start -->
        <aside class="bottom_msg_box">            
        </aside>
        <!-- bottom_msg_box end -->

    </section>
    <!-- search_result end -->

</section>
<!-- content end -->