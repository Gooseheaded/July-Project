#define VECTOR_LIB

vector
	var
		x
		y
		z

	New()
		.=..()
		if(args.len == 3)
			//this is the component format
			x = args[1]
			y = args[2]
			z = args[3]

		else if(args.len == 2)
			//this is the angle angle format
			var/yaw = args[1]
			var/pitch = args[2]

			x = cos(yaw) * cos(pitch)
			y = sin(yaw) * cos(pitch)
			z = sin(pitch)

	proc
		dot(vector/v)
			return (x*v.x + y*v.y + z*v.z)

		cross(vector/v)
			return vec3(y * v.z - z * v.y, -x * v.z + z * v.x, x * v.y - v.x * y)

		magnitude()
			return sqrt(x*x+y*y+z*z)

		magnitudeSquared()
			return (x*x+y*y+z*z)

		projectOnto(vector/b) //src projected upon v
			var/ab = src.dot(b)
			var/bb = b.dot(b)
			return b.multiply(ab/bb)

		unit() //return a unit vector in the same direction
			var/mag = 1/magnitude()
			if(mag == 1) return src
			return vec3(x*mag, y*mag, z*mag)

		matrixMultiply(matrix/m)
			var/x1 = x * m.a + y * m.b + z * m.c
			var/y1 = x * m.d + y * m.e + z * m.f
			var/z1 = z
			return vec3(x1, y1, z1)

		multiply(scalar)
			return vec3(x*scalar, y*scalar, z*scalar)

		scaleToMagnitude(newMagnitude)
			return multiply(newMagnitude/magnitude())

		add(vector/v)
			return vec3(x+v.x, y+v.y, z+v.z)

		subtract(vector/v)
			return vec3(x-v.x, y-v.y, z-v.z)

		randomPerpendicular() //generates a random vector perpendicular to src
			var/vector/random = new(rand(),rand(),rand())
			var/ab = src.dot(random)
			var/bb = src.dot(src)

			return random.subtract(src.multiply(ab/bb))

		rotateAboutAxis(vector/u, angle)
			//returns a new vector of src rotated about axis u by angle degrees
			if(u.magnitudeSquared() != 1)
				//if the given axis is not of unit length
				u = u.unit() //make it of unit length

			var/cos = cos(angle)
			var/sin = sin(angle)
			var/nx = x * (cos + u.x * u.x * (1-cos)) \
				+ y * (u.x * u.y * (1-cos) - u.z * sin) \
				+ z * (u.x * u.z * (1-cos) + u.y * sin)

			var/ny = x * (u.y * u.x * (1-cos) + u.z * sin) \
				+ y * (cos + u.y * u.y * (1-cos)) \
				+ z * (u.y * u.z * (1-cos) - u.x * sin)

			var/nz = x * (u.z * u.x * (1-cos) - u.y * sin) \
				+ y * (u.z * u.y * (1-cos) + u.x * sin) \
				+ z * (cos + u.z * u.z * (1-cos))

			return vec3(nx, ny, nz)

#ifdef QUAT_LIB

		multiplyQuat(quaternion/Q)
			var/angle = 2 * arccos(Q.w)
			var/vector/axis = vec3(Q.x, Q.y, Q.z)
			axis = axis.multiply(1 / (sin(0.5 * angle)))
			return rotateAboutAxis(axis, angle)

#endif

		clone()
			return multiply(1)

		toString()
			return "\<[x], [y], [z]>"

proc
	vec3(x,y,z)
		return new/vector(x,y,z)

	vec2(x,y)
		return new/vector(x,y,0)