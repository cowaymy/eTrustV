<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>CUSTOMER CONTACT</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:145px" />
        <col style="width:*" />
        <col style="width:115px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
        <th scope="row">Status</th>
        <td><span>${detailcontact.name}</span></td>
        <th scope="row">Create By</th>
        <td><span>${detailcontact.userName}
            <c:if test="${not empty detailcontact.crtDt}">
                <c:if test="${detailcontact.crtDt ne '01-01-1900'}">
                    (${detailcontact.crtDt})
                </c:if>
            </c:if>
            </span>
         </td>
    </tr>
    <tr>
        <th scope="row">Initial</th>
        <td><c:if test="${not empty detailcontact.code}">${detailcontact.code}</c:if></td>
        <th scope="row">Update By</th>
        <td>${detailcontact.userName1}
            <c:if test="${not empty detailcontact.updDt}">
                <c:if test="${detailcontact.updDt ne '01-01-1900'}">
                    (${detailcontact.updDt})
                </c:if>
            </c:if>
       </td>
    </tr>
    <tr>
        <th scope="row">Name</th>
        <td>${detailcontact.name1}</td>
        <th scope="row">NRIC</th>
        <td>${detailcontact.nric}</td>
    </tr>
    <tr>
        <th scope="row">DOB</th>
        <td><c:if test="${detailcontact.dob ne '01-01-1900'}">${detailcontact.dob}</c:if></td>
        <th scope="row">Gender</th>
        <td>
            <c:if test="${detailcontact.gender eq 'F'}">
                Female
            </c:if>
            <c:if test="${detailcontact.gender eq 'M'}">
                Male
            </c:if>
        </td>
    </tr>
    <tr>
        <th scope="row">Race</th>
        <td>${detailcontact.codeName}</td>
        <th scope="row">Email</th>
        <td>${detailcontact.email}</td>
    </tr>
    <tr>
        <th scope="row">Tel (Mobile)</th>
        <td>${detailcontact.telM1}</td>
        <th scope="row">Tel (Office)</th>
        <td>${detailcontact.telO }</td>
    </tr>
    <tr>
        <th scope="row">Tel (Residence)</th>
        <td>${detailcontact.telR }</td>
        <th scope="row">Tel (Fax)</th>
        <td>${detailcontact.telf}</td>
    </tr>
    <tr>
        <th scope="row">Department</th>
        <td>${detailcontact.dept}</td>
        <th scope="row">Post</th>
        <td>${detailcontact.pos}</td>
    </tr>
    </tbody>
    </table><!-- table end -->

</section><!-- pop_body end -->
</div>