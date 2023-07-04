<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">

</script>

<style>
.option {font-size:18px;font-weight:bold;display:table; margin:0 auto;color:#25527c;}
.pop_body1{height: -webkit-calc(90vh - 70px);height: -moz-calc(90vh - 70px);height: calc(90vh - 70px); padding:30px; background:#fff; border: 2px solid #fff;
                border-radius: 25px;}
.hide1 {  display: none;
    width: auto;
    height: auto;
    position: absolute;
    left: 70%;
    top: 20%;
    z-index: 1001;
}
.submit{margin-top:10%; display:none;}

</style>

<!-- --------------------------------------DESIGN------------------------------------------------ -->

<div id="vaccineInfoPop" class="popup_wrap size_mid2"><!-- popup_wrap start -->
<section id="content">
    <!-- content start -->
    <form action="#" method="post" id="form" name="form">
        <div id="info" style="padding-top:1%; padding-left: 5%; padding-right: 5%">
        <table class="type1" style="border: none">
            <tbody>
                <tr>
                   <td style="width : 10px"></td>
                    <td><b>Name :</b></td>
                    <td><input type="text" title="IC Number" placeholder="" id="verName" name="verName" disabled /></td>
                    <td><b>NRIC :</b></td>
                    <td><input type="text" title="IC Number" placeholder="" id="verNric" name="verNric" disabled /></td>
                </tr>

               </tbody>
              </table>
              </div>
    </form>
</section>