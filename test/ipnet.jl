using IPNets
using Base.Test
using Compat

if VERSION.minor < 4
    const IPAddr = Base.IpAddr
else
    import Base.IPAddr
end


# IPv4

ip41 = IPv4("1.2.3.4")
ip42 = IPv4("5.6.7.8")

n1 = IPv4Net("1.2.3.0/24")
n2 = IPv4Net("1.2.3.4/24")
n3 = IPv4Net("1.2.3.4/26")
n4 = IPv4Net("5.6.7.0/24")

@test IPv4Net("1.2.3.4", "255.255.255.0") == n1
@test IPv4Net("1.2.3.4", 24) == n1
@test n1 == n2

@test isless(n1,n3) == false
@test isless(n1,n4) == true

@test n1[5] == ip41
@test isless(ip41, ip42) == true
@test in(ip42, n4) == true
@test contains(n4, ip42) == true
@test issubset(n3, n2) == true
@test issubset(n1, n2) == true

@test IPNets.contiguousbitcount(240,UInt8) == 0x04
@test IPNets.contiguousbitcount(252,UInt8) == 0x06
@test_throws ErrorException IPNets.contiguousbitcount(241,UInt8)


# IPv6
ip61 = IPv6("2001:1::4")
ip62 = IPv6("2001:2::8")

o1 = IPv6Net("2001:1::/64")
o2 = IPv6Net("2001:1::4/64")
o3 = IPv6Net("2001:1::4/68")
o4 = IPv6Net("2001:2::8/64")

@test IPv6Net("2001:1::", 64) == o1
@test o1 == o2

@test isless(o1,o3) == false
@test isless(o1,o4) == true

@test o1[5] == ip61
@test isless(ip61, ip62) == true
@test in(ip62, o4) == true
@test contains(o4, ip62) == true

p1 = IPv4Net("1.2.3.4/30")
@test [x for x in p1] == [ip"1.2.3.4", ip"1.2.3.5", ip"1.2.3.6", ip"1.2.3.7"]
p2 = IPv6Net("2001:1::4/126")
@test [x for x in p2] == [ip"2001:1::4",ip"2001:1::5",ip"2001:1::6",ip"2001:1::7"]

@test endof(p1) == 4
@test endof(p2) == 4
@test minimum(p1) == ip"1.2.3.4"
@test minimum(p2) == ip"2001:1::4"
@test maximum(p1) == ip"1.2.3.7"
@test maximum(p2) == ip"2001:1::7"
@test extrema(p1) == (ip"1.2.3.4",ip"1.2.3.7")
@test extrema(p2) == (ip"2001:1::4",ip"2001:1::7")
@test getindex(p1,1:2) == [ip"1.2.3.4", ip"1.2.3.5"]
@test getindex(p2,1:2) == [ip"2001:1::4", ip"2001:1::5"]
